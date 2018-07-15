#include "LinkedList.h"

namespace pf{
	LinkedList::LinkedList():
		head(nullptr)
		,tail(nullptr)
		,length(0)
	{
	}

	LinkedList::~LinkedList(){
		removeAllNodes();
	}

	void LinkedList::appendNode(LinkedListNode *node){
		if(head == nullptr){
			head = tail = node;
		}else{
			tail->next = node;
			node->prev = tail;
			tail = node;
		}

		++length;
	}

	void LinkedList::removeNode(LinkedListNode *node){
		if(node == head){
			head = node->next;
			if(head)
				head->prev = nullptr;
		}else{
			node->prev->next = node->next;
		}

		if(node == tail){
			tail = node->prev;
			if(tail)
				tail->next = nullptr;
		}else{
			node->next->prev = node->prev;
		}

		node->prev = nullptr;
		node->next = nullptr;		

		--length;
	}

	void LinkedList::removeAllNodes(){
		head = nullptr;
		tail = nullptr;
		length = 0;
	}
}