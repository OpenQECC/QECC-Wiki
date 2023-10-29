OPENQASM 2.0;
include "qelib1.inc";

qreg q[7];
creg c[4];

cx q[5], q[2];
cx q[6], q[2];
cx q[6], q[3];
h q[0];
cx q[0], q[2];
cx q[0], q[3];
cx q[0], q[5];
h q[1];
cx q[1], q[3];
cx q[1], q[6];