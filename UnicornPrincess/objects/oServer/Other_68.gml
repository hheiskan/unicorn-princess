/// @description Insert description here
// You can write your code in this editor
var evt_type = ds_map_find_value(async_load, "type");
switch (evt_type)
{
	case network_type_connect:
		var socket = ds_map_find_value(async_load, "socket");
		ds_list_add(sockets, socket);
		break;
	
	case network_type_disconnect:
		var socket = ds_map_find_value(async_load, "socket");
		ds_list_delete(sockets, ds_list_find_index(sockets, socket));
		break;
}

