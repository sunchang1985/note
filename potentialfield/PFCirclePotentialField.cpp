#include "PFCirclePotentialField.h"
#include <math.h>

namespace pf{
	PFCirclePotentialField::PFCirclePotentialField():
		_potential(1)
		,_gradation(1)
		,_radius(0)
	{
		
	}
	PFCirclePotentialField::~PFCirclePotentialField(){
	}

	void PFCirclePotentialField::updateRadius(){		
		_radius = ceil((float)_potential / (float)_gradation) - 1;
	}

	int PFCirclePotentialField::get_potentialBoundsHalfHeight(){
		return _radius;
	}

	int PFCirclePotentialField::get_potentialBoundsHalfWidth(){
		return _radius;
	}

	void PFCirclePotentialField::set_potential(int value){
		_potential = value;
		updateRadius();
	}

	void PFCirclePotentialField::set_gradation(int value){
		_gradation = value;
		updateRadius();
	}

	int PFCirclePotentialField::getLocalPotential(int local_x, int local_y){
		local_x = abs(local_x);
		local_y = abs(local_y);
        
		if(local_x > _radius || local_y > _radius) return 0;

		int distance = local_x > local_y ? local_x : local_y;
		int local_potential = type * (_potential - _gradation * distance);
        if(type < 0) return 0 > local_potential ? local_potential : 0;
        return 0 > local_potential ? 0 : local_potential;        
    }
}