module examples

public class vec2 [f32 x, f32 y]
public private class vec2 [f32 x, f32 y]

class vec3 {
	f32 x;
	f32 y;
	f32 z;
	
	new(f32 x, f32 y, f32 z){
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	f32 length(){
		return math.sqrt(x * x + y * y + z * z);
	}
}

f32 vec2_normalized(f32 x, f32 y){
	f32 length = math.sqrt(x * x + y * y);
	return vec2(x / length, y / length);
}