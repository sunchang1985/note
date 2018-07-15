#pragma once

#include "PFPotentialField.h"

namespace pf{
	class PFRectangularPotentialField : public PFPotentialField
	{
	public:
		PFRectangularPotentialField(int max_potential_half_width, int max_potential_half_height);
		~PFRectangularPotentialField();
		virtual int getLocalPotential(int local_x, int local_y) override;
		virtual int get_potentialBoundsHalfWidth() override;
		virtual int get_potentialBoundsHalfHeight() override;
		void set_potential(int value);
		void set_gradation(int value);
		void set_maxPotentialHalfWidth(int value);
		void set_maxPotentialHalfHeight(int value);
		inline int get_maxPotentialHalfWidth(){
			return _maxPotentialHalfWidth;
		}
		inline int get_maxPotentialHalfHeight(){
			return _maxPotentialHalfHeight;
		}
		inline int get_potential(){
			return _potential;
		}
		inline int get_gradation(){
			return _gradation;
		}
	private:
		int _potential;
		int _gradation;
		int _maxPotentialHalfWidth;
        int _maxPotentialHalfHeight;
        int _boundsHalfWidth;
        int _boundsHalfHeight;
		void updateBounds();
	};
}