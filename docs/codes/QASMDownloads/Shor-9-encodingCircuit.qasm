OPENQASM 2.0;
include "qelib1.inc";

qreg q[9];
creg c[8];

cx q[8], q[6];
cx q[8], q[7];
h q[0];
cx q[0], q[2];
cx q[0], q[3];
cx q[0], q[6];
cx q[0], q[7];
cx q[0], q[8];
h q[1];
cx q[1], q[4];
cx q[1], q[5];
cx q[1], q[6];
cx q[1], q[7];
cx q[1], q[8];