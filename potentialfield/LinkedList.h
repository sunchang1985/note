#pragma once

#include "LinkedListNode.h"

namespace pf{
	class LinkedList
	{
	public:
		LinkedList();
		virtual ~LinkedList();

		LinkedListNode *head;
		LinkedListNode *tail;
		int length;

		void appendNode(LinkedListNode *node);
		void removeNode(LinkedListNode *node);
		void removeAllNodes();
	};
}