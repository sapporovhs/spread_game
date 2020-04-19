shader_type canvas_item;

void vertex(){
	float speed = 2.0;
	float amplitude = 2.0;
	VERTEX += vec2(-sin(TIME*speed)*amplitude/2.0,-sin(TIME*speed)*amplitude/2.0)+ vec2(sin(TIME*speed)*amplitude, sin(TIME*speed)*amplitude)*UV;
	VERTEX.x += (UV.y-0.5)*0.9*sin(TIME);
	VERTEX.y += (UV.x-0.5)*0.9*cos(TIME);
}