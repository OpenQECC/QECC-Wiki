OPENQASM 2.0;
include "qelib1.inc";

qreg q[3];
creg c[2];

cx q[2], q[0];
cx q[2], q[1];