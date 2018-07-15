#pragma once

#include "LinkedListNode.h"

namespace pf{
	/*
	*
	* @author sunchang 2015-6-16
	*
	*/
	class PFPotentialField : public LinkedListNode
	{
	public:
		PFPotentialField();
		virtual ~PFPotentialField();

		enum PF_TYPE
		{
			PF_TYPE_ATTRACT = -1,
			PF_TYPE_REPEL = 1
		};

		int x;
		int y;
		PF_TYPE type;

		virtual int getLocalPotential(int local_x, int local_y) = 0;
		virtual int get_potentialBoundsHalfWidth() = 0;
		virtual int get_potentialBoundsHalfHeight() = 0;
	};
}