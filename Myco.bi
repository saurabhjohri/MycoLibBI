/**
 * Myco model.
 */
model Myco {
	
	// declare constants...
 	const popN = 736
	const sigma_lat = 1/7
	const prop3 = 0.85
	const nu = 0.0
	//const dayNo = 1/365
	const birth = (1/365) * 1/70
	const mu = (1/365) * 1/70
	const sigma_inc = 1/23
	//const sigma_lat = 1/7
	const tau = 1/49
	const tau_md= 1/28

	//const prop3 = 0.85
	const prop4 = 1-0.85//prop3
	const prop5 = 0.1
	const prop6 = 0.10
	const prop7 = 0.05
  
	param beta, prop, T0, kDisp	
  
	state S,E,POS,MD,AC,Pneumo,R
	
	obs Cases_obs
	
	sub parameter {
	    	// python code uses sp.random.rand(1,1)
    		beta ~ uniform(-1,1)
	    	prop ~ uniform(0,1)
	    	T0 ~ uniform(-5,5)
    		kDisp ~ uniform(0,2)
  	}
	
	// priors for initial values over the states
	sub initial {
	    S ~ gaussian((popN-(1/0.85)),10.0)
	    E ~ uniform(0,2)
	    POS ~ log_normal(log(1.0),1.0)
	    MD ~ uniform(0,2)
	    AC ~ uniform(0,2)
	    Pneumo ~ uniform(0,2)
	    R ~ uniform(0,2)
	}

	sub transition(delta=1.0){
	   //FOI = beta * POS/popN
    	   ode{
		//dS/dt = -FOI * S -mu * S
		dS/dt = -(beta * POS/popN) * S -mu * S
		
		dE/dt = (beta * POS/popN) * S -sigma_inc * E -mu * E
		
		dPOS/dt = sigma_inc * E -sigma_lat * POS -mu * POS
		
		dMD/dt = prop3 * sigma_lat * POS -(prop6 * tau_md * MD) - (prop5 * tau_md * MD) -(prop7 * tau * MD) -mu * MD
		
		dAC/dt = prop4 * sigma_lat * POS + prop5 * tau_md * MD -tau * AC -mu * AC
		
		dPneumo/dt = prop6 * tau_md * MD -tau * Pneumo -mu * Pneumo
		
		dR/dt = (tau * Pneumo) +(tau *prop7*MD) + (tau * AC) -mu *R
    	   }
	}

	sub observation {
	    // specify the observation model - poisson
	    // calculate incidence;  matlab code = (prop3 * sigma_lat) * (1-nu) * ue(:,3) * 7
	    
	    /* prop3 = 0.85
	     * sigma_lat = 1/7
	     * nu = 0.0
	     * ue(:,3) POS
	     */
	    Cases_obs ~ log_normal(log((0.85*(1/7))*(1-0.0)*POS*7),1.0)

	}

}
