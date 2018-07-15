#include "PFAgent.h"
#include <typeinfo>

namespace pf{
	PFAgent::PFAgent():
		PFRadialPotentialField()
		,subtractSelfPotentialFromDynamicsMapSum(false)
		,_cols(0)
		,_rows(0)
		,trailLength(10)
	{
	}

	PFAgent::~PFAgent(){
		cleanPrivateDynamicPotentialsMaps();
		cleanTrails();
	}

	int PFAgent::getSelfPotential(int map_x, int map_y){
		return getLocalPotential(map_x - x,map_y - y);
	}

	int PFAgent::getTrailPotential(int map_x, int map_y){
		int potential = 0;

		auto head = _trails.head;
		while(head){
			auto agentTrail = (PFAgentTrail *)head;
			if(agentTrail->map_x == map_x && agentTrail->map_y == map_y)
				potential += agentTrail->potential;

			head = head->next;
		}

		return potential;
	}

	void PFAgent::addPublicDynamicPotentialsMap(PFDynamicPotentialsMap *dynamicPotentialsMap){
		publicDynamicPotentialsMaps.push_back(dynamicPotentialsMap);
		_cols = dynamicPotentialsMap->getCols();
		_rows = dynamicPotentialsMap->getRows();
	}
	void PFAgent::addPrivateDynamicPotentialsMap(PFDynamicPotentialsMap *dynamicPotentialsMap){
		privateDynamicPotentialsMaps.push_back(dynamicPotentialsMap);
		_cols = dynamicPotentialsMap->getCols();
		_rows = dynamicPotentialsMap->getRows();
	}

	void PFAgent::cleanTrails(){
		auto head = _trails.head;
		while(head){
			auto next = head->next;
			auto agentTrail = (PFAgentTrail *)head;
			delete agentTrail;
			head = next;
		}
		_trails.removeAllNodes();
	}

	void PFAgent::cleanPrivateDynamicPotentialsMaps(){
		for(auto it = privateDynamicPotentialsMaps.begin(); it != privateDynamicPotentialsMaps.end(); ++it){
			auto dynamicPotentialsMap = *it;
			auto head = dynamicPotentialsMap->head;
			while(head){
				auto next = head->next;

				if(strcmp(typeid(*head).name(),typeid(PFRectangularPotentialField).name()) == 0){
					delete (PFRectangularPotentialField *)head;					
				}else if(strcmp(typeid(*head).name(),typeid(PFRadialPotentialField).name()) == 0){
					delete (PFRadialPotentialField *)head;
				}else if(strcmp(typeid(*head).name(),typeid(PFCirclePotentialField).name()) == 0){
					delete (PFCirclePotentialField *)head;
				}

				head = next;
			}
		}

		privateDynamicPotentialsMaps.clear();
	}

	int PFAgent::dynamicPotentialsSum(int map_x, int map_y){
		if(publicDynamicPotentialsMaps.empty() && privateDynamicPotentialsMaps.empty()) return 0;

		int sum = 0;

		auto begin = publicDynamicPotentialsMaps.begin();
		auto end = publicDynamicPotentialsMaps.end();
		while(begin != end){
			PFDynamicPotentialsMap *dynamicPotentialsMap = *begin;
			sum += dynamicPotentialsMap->getPotential(map_x,map_y);
			++begin;
		}

		auto begin1 = privateDynamicPotentialsMaps.begin();
		auto end1 = privateDynamicPotentialsMaps.end();
		while(begin1 != end1){
			PFDynamicPotentialsMap *dynamicPotentialsMap = *begin1;
			sum += dynamicPotentialsMap->getPotential(map_x,map_y);
			++begin1;
		}

		return sum;
	}

	void PFAgent::nextPosition(int &next_x,int &next_y,int x_order,int y_order){
		int selfPotential = getSelfPotential(x,y);
		int agentsPotential = dynamicPotentialsSum(x,y);
		int trailPotential = getTrailPotential(x,y);
		int bestPotential = agentsPotential - selfPotential + trailPotential;

		int best_x = x;
		int best_y = y;

		int i = -1;		
		while(i < 2)
		{
			int xx = x + i * x_order;
			if(xx > -1 && xx < _cols){
				int j = -1;
				while(j < 2){
					int yy = y + j * y_order;

					if(i == 0 && j == 0){
						++j;
						continue;
					}

					if(yy > -1 && yy < _rows){
						int comparingPotential = dynamicPotentialsSum(xx,yy) - getSelfPotential(xx,yy) + getTrailPotential(xx,yy);
						if(comparingPotential < bestPotential){
							bestPotential = comparingPotential;
							best_x = xx;
							best_y = yy;
						}
					}

					++j;
				}
			}			
			++i;
		}

		next_x = best_x;
		next_y = best_y;

		if(next_x == x && next_y == y){
			if(_trails.length > trailLength){
				auto head = _trails.head;
				_trails.removeNode(head);
				
				auto agentTrail = (PFAgentTrail *)head;
				agentTrail->map_x = x;
				agentTrail->map_y = y;

				_trails.appendNode(agentTrail);
			}else if(trailLength > 0){
				_trails.appendNode(new PFAgentTrail(x,y,type * get_potential()));
			}
		}
	}

	PFAgentTrail::PFAgentTrail(int map_x,int map_y,int potential):
		map_x(map_x),
		map_y(map_y),
		potential(potential)
	{
	}

	PFAgentTrail::~PFAgentTrail(){
	}
}