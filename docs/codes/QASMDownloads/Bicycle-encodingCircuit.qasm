OPENQASM 2.0;
include "qelib1.inc";

qreg q[8];
creg c[6];

cx q[6], q[3];
cx q[7], q[3];
cx q[7], q[4];
cx q[7], q[5];
h q[0];
cx q[0], q[3];
cx q[0], q[6];
cx q[0], q[7];
h q[1];
cx q[1], q[3];
cx q[1], q[4];
cx q[1], q[6];
h q[2];
cx q[2], q[3];
cx q[2], q[5];
cx q[2], q[6];