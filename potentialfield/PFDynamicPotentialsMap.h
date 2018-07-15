#pragma once

#include "LinkedList.h"
#include "PFPotentialField.h"

namespace pf{
	class PFDynamicPotentialsMap : public LinkedList
	{
	public:
		PFDynamicPotentialsMap(int cols,int rows);
		virtual ~PFDynamicPotentialsMap();

		void addPotentialField(PFPotentialField *potential_field);
		void removePotentialField(PFPotentialField *potential_field);
		void removeAllPotentialFields();
		int getPotential(int map_x, int map_y);
		int getCols();
		int getRows();
	private:
		int _cols;
		int _rows;		
	};
}