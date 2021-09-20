
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

var on_floor = place_meeting(x, y + 1, oWall);
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
	jump_count++;
	jump = 1;
}

if (place_meeting(x + hsp, y, oWall))
{
	while (!place_meeting(x + sign(hsp), y, oWall))
	{
		x = x + sign(hsp);
	}
	hsp = 0;
}

x = x + hsp;

if (place_meeting(x, y + vsp, oWall))
{
	while (!place_meeting(x, y + sign(vsp), oWall))
	{
		y = y + sign(vsp);
	}
	vsp = 0;
}

y = y + vsp;

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
	if (sign(vsp) > 0) image_index = 1; else image_index = 0;
}
else
{
	image_speed = 1;
	if (hsp == 0)
	{
		sprite_index = sEmiliaIdle;	
	}
	else
	{
		sprite_index = sEmiliaRunning;
	}
}

// if sprites would face right I could remove that -1
if (hsp != 0) image_xscale = sign(hsp) * -1;

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