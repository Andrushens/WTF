abstract class Deque<E> {
  void addFirst(E data);
  void addLast(E data);
  E getFirst();
  E getLast();
  bool offerFirst(E data);
  bool offerLast(E data);
  E pop();
  void push(E data);
  E? peekFirst();
  E? peekLast();
  E? pollFirst();
  E? pollLast();
  E removeLast();
  E removeFirst();
  bool removeLastOccurrence(E data);
  bool removeFirstOccurrence(E data);
}

class Node<E> {
  E data;
  Node<E>? next;
  Node<E>? prev;

  Node(this.data, [this.prev, this.next]) {
    prev?.next = this;
    next?.prev = this;
  }

  @override
  String toString() {
    return data.toString();
  }
}

class DoubleLinkedList<E> implements Deque<E> {
  int size = 0;
  int? maxSize;
  Node<E>? head;
  Node<E>? tail;

  DoubleLinkedList([this.maxSize]) {}

  DoubleLinkedList.fromList(List<E> list) {
    list.forEach((element) {
      addLast(element);
    });
  }

  static DoubleLinkedList<E> parse<E>(List<E> list) {
    return DoubleLinkedList.fromList(list);
  }

  bool empty() => head == null;

  void show() {
    Node<E>? cur = head;
    while (cur != null) {
      print(cur);
      cur = cur.next;
    }
  }

  void showBack() {
    Node<E>? cur = tail;
    while (cur != null) {
      print(cur);
      cur = cur.prev;
    }
  }

  void clear() {
    while (!empty()) {
      removeFirst();
    }
  }

  void add(int idx, E data) {
    if (idx < 0 || idx > size) {
      throw Exception('IllegalIndexException');
    }

    if (size == maxSize) {
      throw Exception('IllegalStateException');
    }

    Node<E>? cur = head;

    if (idx == 0) {
      head = new Node(data, null, head);
      tail = head!.next == null ? head : tail;
    } else {
      while (idx > 1) {
        idx--;
        cur = cur!.next;
      }

      cur!.next = new Node(data, cur, cur.next);
      tail = cur.next?.next == null ? cur.next : tail;
    }

    size++;
  }

  void remove(int idx) {
    if (idx < 0 || idx > size - 1) {
      throw Exception('IllegalIndexException');
    }

    Node<E>? cur = head;

    if (idx == 0) {
      head = head!.next;
      head?.prev = null;
      tail = head == null ? null : tail;
    } else {
      while (idx > 0) {
        idx--;
        cur = cur!.next;
      }

      cur!.prev!.next = cur.next;
      cur.next?.prev = cur.prev;
      tail = cur.next == null ? cur.prev : tail;
    }

    size--;
  }

  void addFirst(E data) {
    if (size == maxSize) {
      throw Exception('IllegalStateException');
    }
    add(0, data);
  }

  void addLast(E data) {
    if (size == maxSize) {
      throw Exception('IllegalStateException');
    }

    if (empty()) {
      head = tail = new Node(data);
    } else {
      tail!.next = new Node(data, tail);
      tail = tail!.next;
    }

    size++;
  }

  E getFirst() {
    if (empty()) {
      throw Exception('NoSuchElementException');
    }
    return head!.data;
  }

  E getLast() {
    if (empty()) {
      throw Exception('NoSuchElementException');
    }
    return tail!.data;
  }

  bool offerFirst(E data) {
    if (size != maxSize) {
      addFirst(data);
      return true;
    }
    return false;
  }

  bool offerLast(E data) {
    if (size != maxSize) {
      addLast(data);
      return true;
    }
    return false;
  }

  E pop() {
    return removeFirst();
  }

  void push(E data) {
    addFirst(data);
  }

  E? peekFirst() {
    if (empty()) {
      return null;
    }
    return getFirst();
  }

  E? peekLast() {
    if (empty()) {
      return null;
    }
    return getLast();
  }

  E? pollFirst() {
    if (empty()) {
      return null;
    }
    return removeFirst();
  }

  E? pollLast() {
    if (empty()) {
      return null;
    }
    return removeLast();
  }

  E removeFirst() {
    if (empty()) {
      throw Exception('NoSuchElementException');
    }

    E value = head!.data;
    remove(0);

    return value;
  }

  E removeLast() {
    if (empty()) {
      throw Exception('NoSuchElementException');
    }

    E value = tail!.data;
    tail = tail?.prev;
    tail?.next = null;
    size--;

    if (size == 0) {
      head = null;
    }

    return value;
  }

  bool removeLastOccurrence(E data) {
    Node<E>? cur = tail;
    int idx = size - 1;

    while (cur != null && cur.data != data) {
      cur = cur.prev;
      idx--;
    }

    if (cur != null) {
      remove(idx);
      return true;
    }

    return false;
  }

  bool removeFirstOccurrence(E data) {
    Node<E>? cur = head;
    int idx = 0;

    while (cur != null && cur.data != data) {
      cur = cur.next;
      idx++;
    }

    if (cur != null) {
      remove(idx);
      return true;
    }

    return false;
  }

  Node<E>? operator [](int idx) {
    if (idx < 0 || idx > size - 1) {
      throw Exception('IllegalIndexException');
    }

    Node<E>? cur = head;

    while (idx > 0 && cur != null) {
      idx--;
      cur = cur.next;
    }

    return cur;
  }

  void operator []=(int idx, E data) => this[idx]!.data = data;
}
