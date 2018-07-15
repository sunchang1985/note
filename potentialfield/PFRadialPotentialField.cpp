#include "PFRadialPotentialField.h"
#include <math.h>

namespace pf{
	PFRadialPotentialField::PFRadialPotentialField():
		_potential(1)
		,_gradation(1)
		,_radius(0)
	{
		
	}
	PFRadialPotentialField::~PFRadialPotentialField(){
	}

	void PFRadialPotentialField::updateRadius(){		
		_radius = ceil((float)_potential / (float)_gradation) - 1;
	}

	int PFRadialPotentialField::get_potentialBoundsHalfHeight(){
		return _radius;
	}

	int PFRadialPotentialField::get_potentialBoundsHalfWidth(){
		return _radius;
	}

	void PFRadialPotentialField::set_potential(int value){
		_potential = value;
		updateRadius();
	}

	void PFRadialPotentialField::set_gradation(int value){
		_gradation = value;
		updateRadius();
	}

	int PFRadialPotentialField::getLocalPotential(int local_x, int local_y){
        int distance = abs(local_x) + abs(local_y);//Âü¹þ¶Ù¾àÀë
        if(distance > _radius) return 0;		

		int local_potential = type * (_potential - _gradation * distance);

        if(type < 0) return 0 > local_potential ? local_potential : 0;

        return 0 > local_potential ? 0 : local_potential;
    }
}