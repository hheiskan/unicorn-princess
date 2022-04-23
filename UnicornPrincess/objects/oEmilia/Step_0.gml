var bbox_side;

if (win_state) return;

key_left = keyboard_check(vk_left);
key_right = keyboard_check(vk_right);
key_jump = keyboard_check_pressed(vk_space);
if (gamepad_is_connected(0))
{
	key_left = gamepad_button_check(0, gp_padl);
	key_right = gamepad_button_check(0, gp_padr);
	key_jump = gamepad_button_check_pressed(0, gp_face1);
}

var move = key_right - key_left;

hsp = move * walksp;

vsp = vsp + grv;


// Fractional Collisions / Pixel Perfect (https://pastebin.com/bzEK3sre)
hsp_final = hsp + hsp_f;
hsp_f = hsp_final - floor(abs(hsp_final))*sign(hsp_final);
hsp_final -= hsp_f;

vsp_final = vsp + vsp_f;
vsp_f = vsp_final - floor(abs(vsp_final))*sign(vsp_final);
vsp_final -= vsp_f;

//var on_floor = place_meeting(x, y + 1, oWall);
var on_floor = tilemap_get_at_pixel(collisionMap, x, bbox_bottom + 1) != 0;
if (on_floor) jump_count = 0;

if (place_meeting(x, y, oDiamond))
{
	var diamond_instance = instance_place(x, y, oDiamond);
	instance_destroy(diamond_instance);
	audio_play_sound(sndDiamond, 1, 0);
}

var jump = 0;
if (on_floor || jump_count < 2) && (key_jump)
{
	vsp = -6;
	vsp_final = -6;
	vsp_f = 0;
	jump_count++;
	jump = 1;
}

if (hsp_final > 0) bbox_side = bbox_right; else bbox_side = bbox_left;
if (tilemap_get_at_pixel(collisionMap, bbox_side + hsp_final, bbox_top) != 0) ||  (tilemap_get_at_pixel(collisionMap, bbox_side + hsp_final, bbox_bottom) != 0)
{
	if (hsp_final > 0) x = x - (x mod 16) + 15 - (bbox_right - x);
	else if (hsp_final < 0) x = x - (x mod 16) - (bbox_left - x);
	hsp_final = 0;
	hsp = 0;
}

x += hsp_final;

if (vsp_final > 0) bbox_side = bbox_bottom; else bbox_side = bbox_top;
if (tilemap_get_at_pixel(collisionMap, bbox_left, bbox_side + vsp_final) != 0) ||  (tilemap_get_at_pixel(collisionMap, bbox_right, bbox_side + vsp_final) != 0)
{
	if (vsp_final > 0) y = y - (y mod 16) + 15 - (bbox_bottom - y);
	else if (vsp_final < 0) y = y - (y mod 16) - (bbox_top - y);
	vsp_final = 0;
	vsp = 0;
}

y += vsp_final;

// Animation
if (jump)
{
	var inst = instance_create_layer(x, y + 7, "Player", oDust);
	audio_play_sound(sndJump, 1, 0);
}
if (!on_floor)
{
	sprite_index = sEmiliaAir;
	image_speed = 0;
	if (sign(vsp_final) > 0) image_index = 1; else image_index = 0;
}
else
{
	image_speed = 1;
	if (hsp_final == 0)
	{
		sprite_index = sEmiliaIdle;	
	}
	else
	{
		sprite_index = sEmiliaRunning;
	}
}

// if sprites would face right I could remove that -1
if (hsp_final != 0) image_xscale = sign(hsp_final) * -1;

if (instance_number(oDiamond) = 0)
{
	win_state = 1;
	var cx = camera_get_view_x(view_camera[0]) + (camera_get_view_width(view_camera[0])/2);
	var cy = camera_get_view_y(view_camera[0]) + (camera_get_view_height(view_camera[0])/2);
	instance_create_layer(cx, cy, "Player", oGreatWork);
	audio_stop_all();
	audio_play_sound(sndDiamond, 1, 0);
	audio_play_sound(sndWin, 1, 0)
}

if (layer_exists("bStars"))
{
	var cam = view_get_camera(0);
	var cam_x = camera_get_view_x(cam);
	var cam_y = camera_get_view_y(cam); 
	layer_x("bStars", cam_x / 2);
	layer_y("bStars", cam_y / 2);
}
