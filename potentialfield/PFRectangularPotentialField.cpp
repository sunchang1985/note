#include "PFRectangularPotentialField.h"
#include <math.h>

namespace pf{
	PFRectangularPotentialField::PFRectangularPotentialField(int max_potential_half_width, int max_potential_half_height):
		_maxPotentialHalfWidth(max_potential_half_width),
		_maxPotentialHalfHeight(max_potential_half_height),
		_potential(1),
		_gradation(1)
	{
		updateBounds();
	}

	PFRectangularPotentialField::~PFRectangularPotentialField(){
	}

	int PFRectangularPotentialField::getLocalPotential(int local_x, int local_y){
		local_x = abs(local_x);
		local_y = abs(local_y);
		if(local_x <= _maxPotentialHalfWidth && local_y <= _maxPotentialHalfHeight) return type * _potential;

        if(local_x <= _boundsHalfWidth && local_y <= _boundsHalfHeight){
            int distance;

            if(local_x > _maxPotentialHalfWidth && local_y > _maxPotentialHalfHeight){
                distance = local_x - _maxPotentialHalfWidth + local_y - _maxPotentialHalfHeight;
            }
            else if(local_x > _maxPotentialHalfWidth){
                distance = local_x - _maxPotentialHalfWidth;
            }
            else if(local_y > _maxPotentialHalfHeight){
                distance = local_y - _maxPotentialHalfHeight;
            }

			int local_potential = type * (_potential - _gradation * distance);
            if(type < 0) return 0 > local_potential ? local_potential : 0;
            return 0 > local_potential ? 0 : local_potential;
        }

        return 0;
	}		
	void PFRectangularPotentialField::set_potential(int value){
		_potential = value;
		updateBounds();
	}
	void PFRectangularPotentialField::set_gradation(int value){
		_gradation = value;
		updateBounds();
	}
	void PFRectangularPotentialField::set_maxPotentialHalfWidth(int value){
		_maxPotentialHalfWidth = value;
		updateBounds();
	}
	void PFRectangularPotentialField::set_maxPotentialHalfHeight(int value){
		_maxPotentialHalfHeight = value;
		updateBounds();
	}
	void PFRectangularPotentialField::updateBounds(){
		_boundsHalfWidth = _maxPotentialHalfWidth + ceil((float)_potential / (float)_gradation) - 1;
        _boundsHalfHeight = _maxPotentialHalfHeight + ceil((float)_potential / (float)_gradation) - 1;
	}
	int PFRectangularPotentialField::get_potentialBoundsHalfHeight(){
		return _boundsHalfHeight;
	}

	int PFRectangularPotentialField::get_potentialBoundsHalfWidth(){
		return _boundsHalfWidth;
	}
}