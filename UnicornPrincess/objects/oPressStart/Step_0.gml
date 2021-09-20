/// @description Insert description here
// You can write your code in this editor
var start = keyboard_check_pressed(vk_space);
if (gamepad_is_connected(0))
{
	start = gamepad_button_check_pressed(0, gp_face1);
}

if (start)
{
	audio_play_sound(sndMenuSelect, 1, 0);
	image_speed = 5;
	alarm[0] = 2 * room_speed;
	//room_goto(1)
}
