open Unix

let () = 
        let socket = socket PF_INET SOCK_STREAM 0 in
        let _ = bind socket (ADDR_INET (inet_addr_any, 8080)) in
        let _ = listen socket 5 in

        let _ = print_endline "Server is listening on port 8080" in

        (* Accept connections in a loop *)

        let rec accept_connections () =
            let (client_socket, _) = accept socket in
            let _ = print_endline "Accepted a connection" in
            let response : string = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 15\r\n\r\nHello, client!\n" in
            let response_length = String.length response in
            let _ = write_substring client_socket response 0 response_length in
            let _ = close client_socket in accept_connections () in
        accept_connections ()
