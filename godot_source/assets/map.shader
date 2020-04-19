shader_type canvas_item;

void fragment(){
	if(texture(TEXTURE,UV).b < 0.4+sin(TIME/5.0)*0.05){
		COLOR.rg = texture(TEXTURE,UV).rg+vec2(0.25);
		COLOR.r -=0.3;
		COLOR.rgb -= vec3(0.3)
	}
	else{
		COLOR.rb = texture(TEXTURE,UV).rb;
		COLOR.r +=0.3;
		COLOR.rgb -= vec3(0.4)
	}
	COLOR.r = texture(TEXTURE,UV).r-0.1*cos(TIME/4.0*3.1415*2.0);
	COLOR.g = texture(TEXTURE,UV).b-0.1*sin(TIME/4.0*3.1415*2.0);
	COLOR.a = texture(TEXTURE,UV).a;
	COLOR.rgb = COLOR.rgb+vec3(-0.2*sin(TIME/4.0*3.1415*2.0)-0.2);
}