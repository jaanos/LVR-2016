// This tutorial models a certain kind of state machine in Alloy

// A state machine is a set of states.
// Each state q has a successor relation. 
//     q.successors is the set of possible next states following state q

sig State { 
	successors: set State
} 

// There is exactly one initial state

one sig Initial extends State { }

// There is a set of final states
// Each final state has an empty set of successors

some sig Final extends State { } { no successors }

// The kind of state machine we are modelling has two other kinds of state: 
// yellow states and black states.
// By using sig declarations in Alloy these sets are disjoint by default.
// We add an axiom (a "fact") asserting that every state is initial, final, yellow or black

sig Yellow extends State { } 
sig Black extends State { } 
fact { State = Initial + Final + Yellow + Black }

// The 0-arity predicate findModel below expresses that there exist black, yellow and final states
pred findModel { #Final > 0 && #Black > 0 && #Yellow > 0 }

// The run command below checks to see if the predicate can be satisfied in scope 1
run findModel for 4

// *** EXERCISE 1 ***
// (a) Find the smallest  scope in which findModel is satisfiable
// (b) Look at the model generated by clicking on Instance
//	To improve the display of the model click on Theme
//	Click on sig Black in the left-hand menu and colour Black states black
//	Similarly colour Yellow states yellow, the initial state green and final states red
//	Click on successors and delete the label from the text box in the top left corner
//	If there is a funny $findModel relation displayed click on that and set "show as arcs" to off
//	Click on Apply and then Close
// The model should now display nicely
// (c)  Look at further models by clicking on Next
//	Also run findModel again in larger scope (not too large) to generate larger models

// *** EXERCISE 2 ***
// Say that a state is deadlocked if its successors are empty.
// The sig declaration for Final requires final stated to be deadlocked
// Add an axiom stating that only Final states can deadlock
// (You may find it useful to use a comprehension term { q: A | P }
//   which defines the subset of those q in set A that satisfy property P)
// For a good reference on the logic of Alloy look at the slides for Session 1 of: 
//    http://alloy.mit.edu/alloy/tutorials/day-course/

// After this, and all subsequent exercises involving the addition of new facts run findModel
// in suitable scope and use the Next button to again explore the range of models available

fact { {s: State | no s.successors} in Final}

// *** EXERCISE 3 ***
// Add an axiom stating that every state is reachable from the initial state

fact { State in Initial.*successors }

// *** EXERCISE 4 ***
// Black nodes are intended to represent error states. 
// When an execution reaches a black node it has to be corrected by eventually
// resetting the system by returning it to the Initial node.
// Add an axiom stating that the initial node is reachable from every black node

fact { all s: Black | Initial in s.^successors }

//*** EXERCISE 5 ***
// Yellow states are intended to represent non-error intermediate states that 
// may be encountered en-route to arriving at a final state
// Add an axiom stating that every yellow state has a path to a final state

fact { all s: Yellow | some Final & s.^successors }

// *** EXERCISE 6 ***
// In this exercise we use the "assert" command to state a property that we
// hope follows from the axioms.
// The property is that every state has a path to a final state
// complete the assert command below by filling in the property
// between the curly braces.

assert  finishable { all s: State | some Final & s.*successors }

// Modify the check command below to check finishable in a sufficiently large  scope to
// be confident whether or not the property is true.

check finishable for 4

// If the property is not true then can you fix the model to make it true?

// *** EXERCISE 7 ***
// There is one further property we want to axiomatize.
// We want to force the system to reset after a Black state.
// This can be achieved by requiring that 
// every path to a final state from a black state goes through the initial state.
// Add this as an axiom.
// (Hint, you might need to use set operators to define a derived relation.)

fact { no Final & Black.^(successors - (State -> Initial)) }

// Additional requirement: a yellow state has a successor as a final state
fact { some Yellow & successors.Final }