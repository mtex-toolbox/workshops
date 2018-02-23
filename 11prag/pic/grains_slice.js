

clip = scene.createClippingPlane();

//key handler to control speed
keyEventHandler = new KeyEventHandler();
keyEventHandler.onKeyDown = true;
keyEventHandler.onEvent = function(e) {
	switch(e.characterCode) {	
	case 30: //key up
		clip.transform.translateInPlace(new Vector3(0,0,.1));
    break;

	case 31: //key down
		clip.transform.translateInPlace(new Vector3(0,0,-.1));
    break;
	}
	
};
runtime.addEventHandler(keyEventHandler);