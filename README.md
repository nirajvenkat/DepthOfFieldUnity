# Depth Of Field Unity project

![Alt text](/DOF\ Project/Capture.PNG?raw=true "DOF")

This project showcases a depth of field effect in Unity. I use a raycast from the player's forward vector to determine which object should be in view. The object's distance is then sent to a postprocessing script that computes depth of field, using this distance as a focal length.

My code is in the Assets/Scripts folder.

##Problems:
My original plan was to write a depth of field shader myself. I wrote a shader in GLSL, however, Unity does not recognize my graphics card and gives me the error: "No subshaders can run on this graphics card." This problem arises with Cg shaders too, so it is not exclusive to GLSL. As a result, I am using the default DepthOfFieldScatter image effect found in Unity Pro.
