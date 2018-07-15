#include "LinkedListNode.h"

namespace pf{
	LinkedListNode::LinkedListNode():
		prev(nullptr),
		next(nullptr)
	{
	}

	LinkedListNode::~LinkedListNode(){
		prev = nullptr;
		next = nullptr;
	}
}