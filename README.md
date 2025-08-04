# ARM Assembly Heap Builder & Search Tool 🧮

This project is an implementation of a **min-heap construction and element search system** using **ARM Assembly Language**. It was developed during my **early university coursework** for the System Programming course.

The program sorts a list of integers into a min-heap and allows searching for a specific element within the heap.

---

## 📋 Features

- Read unsorted integers from memory
- Automatically build a **min-heap**
- Support searching for any value in the heap
- Returns whether the value exists and its address (if found)
- Structured use of heapify and heapify_down subroutines
- Implemented with proper stack management and register handling

---

## 🧠 Educational Focus

This project was designed to:
- Strengthen low-level programming skills
- Understand memory management, pointers, and recursion in assembly
- Practice heap data structures in non-high-level languages
- Explore modular design in assembly (using procedures and stack)

---

## 🔧 How It Works

### Memory Definitions:
- `unsorted_array`: Holds the original unsorted values
- `min_heap`: Stores the heap after construction
- `sorted_array`: Reserved (not used in final version)

### Key Labels and Subroutines:

| Subroutine     | Purpose                                             |
|----------------|-----------------------------------------------------|
| `main`         | Main entry point, triggers build and find          |
| `build`        | Builds the heap from the unsorted array            |
| `heapify`      | Applies heapify to structure the heap              |
| `heapify_down` | Ensures the heap property from parent to children  |
| `find`         | Searches the heap for a target value               |

---

## 🚀 How to Run

> Requires an ARM Assembly emulator like **Keil uVision**, **ARM DS-5**, or **QEMU**.

1. Open the project in your ARM development environment
2. Assemble and link the `.s` file
3. Run the program in simulation mode
4. Check register values and memory:
   - `R0` = Result of `find`: `1` (found) or `0` (not found)
   - `R1` = Address of found value if exists
