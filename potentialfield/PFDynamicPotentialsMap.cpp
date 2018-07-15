#include "PFDynamicPotentialsMap.h"

namespace pf{
	PFDynamicPotentialsMap::PFDynamicPotentialsMap(int cols,int rows):
		_cols(cols),
		_rows(rows)
	{
	}

	PFDynamicPotentialsMap::~PFDynamicPotentialsMap(){
		
	}

	void PFDynamicPotentialsMap::addPotentialField(PFPotentialField *potential_field){
		appendNode(potential_field);
	}

	void PFDynamicPotentialsMap::removePotentialField(PFPotentialField *potential_field){
		removeNode(potential_field);
	}

	void PFDynamicPotentialsMap::removeAllPotentialFields(){
		removeAllNodes();
	}

	int PFDynamicPotentialsMap::getCols(){
		return _cols;
	}

	int PFDynamicPotentialsMap::getRows(){
		return _rows;
	}

	int PFDynamicPotentialsMap::getPotential(int map_x, int map_y){
		int potential = 0;
		auto it = head;
		while(it){
			auto field = (PFPotentialField*)it;
			potential += field->getLocalPotential(map_x - field->x, map_y - field->y);
			it = it->next;
		}
        return potential;
	}
}