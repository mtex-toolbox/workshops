


var mov = 0;
var shift = new Array();
shift[0] = new Vector3(0.,0.5,1.);
shift[1] = new Vector3(0.,0.,1.);
shift[2] = new Vector3(0,1.,-.5);
shift[3] = new Vector3(-1.5,-1,-.5);
shift[4] = new Vector3(0.5,0.,1.);
shift[5] = new Vector3(0.,0.,0.);
shift[6] = new Vector3(-1.,-1.,0.);

offset = function(s){
	for (var i=0; i < scene.meshes.count; i++) {
		scene.meshes.getByIndex(i).transform.translateInPlace(shift[i].scale(s));
	}
}

//key handler to control speed
keyEventHandler = new KeyEventHandler();
keyEventHandler.onKeyDown = true;
keyEventHandler.onEvent = function(e) {
	
	switch(e.characterCode) {	
		case 28: //key up
			if (mov<50){
				mov = mov+1;
				offset(-.1);
			}
		break;

		case 29: //key down
			if (mov>0){
				mov = mov-1;
				offset(.1);
			break;
		}		 
	}
	
};
runtime.addEventHandler(keyEventHandler);