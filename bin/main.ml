let ( let* ) = Lwt.bind

module Pages = struct
  let index (todos : (int * string) list) =
    let todos =
      List.fold_left
        (fun str (_, todo) -> Format.asprintf "%s<li>%s</li>" str todo)
        ""
        todos
    in
    Format.asprintf "<ul>%s</ul>" todos
    ^ {|
  <form action="/todo" method="post">
  <label for="task">Task</label>
  <input id="task" name="task" type="text" />
  <input type="submit" value="Create" />
  </form>
  |}
  ;;
end

module Queries = struct
  open Caqti_template.Create

  let create_todo = static T.(string -->. unit) "INSERT INTO todos (task) VALUES (?)"
  let list_todo = static T.(unit -->* t2 int string) "SELECT * FROM todos"
end

module Routes = struct
  let index =
    Dream.get "/" (fun req ->
      Dream.sql req (fun conn ->
        let module Conn = (val conn : Caqti_lwt.CONNECTION) in
        let* result = Conn.collect_list Queries.list_todo () in
        let todos = Result.get_ok result in
        Dream.html (Pages.index todos)))
  ;;

  let create_todo =
    Dream.post "/todo" (fun req ->
      let* form_result = Dream.form ~csrf:false req in
      let form_data =
        match form_result with
        | `Ok v -> v
        | _ -> []
      in
      Dream.sql req (fun conn ->
        let module Conn = (val conn : Caqti_lwt.CONNECTION) in
        let task_opt = List.assoc_opt "task" form_data in
        let* result =
          Conn.exec Queries.create_todo (Option.value ~default:"ERRO" task_opt)
        in
        let () = Result.get_ok result in
        Dream.redirect req "/"))
  ;;
end

let () =
  let router = Dream.router [ Routes.index; Routes.create_todo ] in
  Dream.run
    (Dream.sql_pool
       "postgresql://postgres:12344@localhost:5432/ocamlweb"
       (Dream.logger router))
;;
