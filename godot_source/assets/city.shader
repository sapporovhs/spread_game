shader_type canvas_item;

void fragment(){
	COLOR.r = texture(TEXTURE,UV).r+0.1*cos(TIME/10.0*3.1415*2.0);
	COLOR.g = texture(TEXTURE,UV).r+0.1*sin(TIME/10.0*3.1415*2.0);
	COLOR.a = texture(TEXTURE,UV).a;
	COLOR.rgb = COLOR.rgb+vec3(-0.3*sin(TIME/10.0*3.1415*2.0)-0.3);
}