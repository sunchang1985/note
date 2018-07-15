#pragma once

namespace pf{
	class LinkedListNode
	{
	public:
		LinkedListNode();
		~LinkedListNode();	

		LinkedListNode *prev;
		LinkedListNode *next;
	};
}