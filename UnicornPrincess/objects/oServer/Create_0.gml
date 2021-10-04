/// @description Insert description here
// You can write your code in this editor
global.server_uid = network_create_server(network_socket_tcp, 18122, 2);
server_buffer = buffer_create(1024, buffer_fixed, 1);
sockets = ds_list_create();
