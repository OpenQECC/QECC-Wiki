OPENQASM 2.0;
include "qelib1.inc";

qreg q[8];
creg c[5];

cx q[5], q[4];
cx q[6], q[4];
cx q[7], q[4];
h q[0];
s q[0];
cx q[0], q[4];
cx q[0], q[5];
cy q[0], q[6];
h q[1];
s q[1];
cz q[1], q[0];
cx q[1], q[4];
cy q[1], q[5];
cx q[1], q[7];
h q[2];
s q[2];
cz q[2], q[0];
cx q[2], q[4];
cz q[2], q[5];
cx q[2], q[6];
cy q[2], q[7];
h q[3];
cz q[3], q[0];
cz q[3], q[1];
cx q[3], q[5];
cy q[3], q[6];
cy q[3], q[7];
z q[2];
z q[3];