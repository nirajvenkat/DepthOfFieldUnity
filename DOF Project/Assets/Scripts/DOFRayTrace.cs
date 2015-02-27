using UnityEngine;
using System.Collections;

public class DOFRayTrace : MonoBehaviour {

	//Player position
	public Transform origin; 
	//Raycast position
	public GameObject target; 
	
	
	//Used for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

		//Ray pointing toward POV of player
		Ray ray = new Ray (origin.transform.position, origin.transform.forward);
		RaycastHit hit = new RaycastHit ();
		
		if (Physics.Raycast (ray, out hit, Mathf.Infinity)) {

			//Reposition the target GameObject to the position
			target.transform.position = hit.point;
			Debug.DrawRay (origin.transform.position, target.transform.position, Color.cyan);
		} else {
			Debug.DrawRay (origin.transform.position, origin.transform.forward, Color.cyan);
		}
		
	}
	
}
