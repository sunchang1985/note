#pragma once

#include "PFPotentialField.h"

namespace pf{
	/*
	*
	* @author sunchang 2015-6-16
	*
	*/
	class PFRadialPotentialField : public PFPotentialField
	{
	public:
		PFRadialPotentialField();
		virtual ~PFRadialPotentialField();
		
		virtual int getLocalPotential(int local_x, int local_y) override;
		virtual int get_potentialBoundsHalfWidth() override;
		virtual int get_potentialBoundsHalfHeight() override;
		void set_potential(int value);
		void set_gradation(int value);
		inline int get_potential(){
			return _potential;
		}
		inline int get_gradation(){
			return _gradation;
		}		
	private:
		int _potential;
		int _gradation;
		int _radius;
		void updateRadius();
	};
}