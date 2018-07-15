#include "PFPotentialField.h"

namespace pf{
	PFPotentialField::PFPotentialField():
		x(0)
		,y(0)
		,type(PFPotentialField::PF_TYPE_REPEL)
	{
	}

	PFPotentialField::~PFPotentialField(){
	}
}