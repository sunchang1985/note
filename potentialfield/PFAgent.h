#pragma once

#include <vector>
#include "PFDynamicPotentialsMap.h"
#include "PFRadialPotentialField.h"
#include "PFRectangularPotentialField.h"
#include "PFCirclePotentialField.h"

namespace pf{
	class PFAgent : public PFRadialPotentialField
	{
	public:
		PFAgent();
		virtual ~PFAgent();

		bool subtractSelfPotentialFromDynamicsMapSum;
		int trailLength;
		int getSelfPotential(int map_x, int map_y);
		int getTrailPotential(int map_x, int map_y);
		void addPublicDynamicPotentialsMap(PFDynamicPotentialsMap *dynamicPotentialsMap);
		void addPrivateDynamicPotentialsMap(PFDynamicPotentialsMap *dynamicPotentialsMap);		
		void cleanPrivateDynamicPotentialsMaps();
		void cleanTrails();
		std::vector<PFDynamicPotentialsMap *> publicDynamicPotentialsMaps;
		std::vector<PFDynamicPotentialsMap *> privateDynamicPotentialsMaps;
		void nextPosition(int &next_x,int &next_y,int x_order,int y_order);
		LinkedList _trails;
	private:
		int _cols;
		int _rows;
		
		int dynamicPotentialsSum(int map_x, int map_y);
	};

	class PFAgentTrail : public LinkedListNode
	{
	public:
		PFAgentTrail(int map_x,int map_y,int potential);
		virtual ~PFAgentTrail();

		int map_x;
		int map_y;
		int potential;
	};
}