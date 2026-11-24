#include <iostream>
#include <vector>
#include <iomanip>

class AdderSimulator {
public:
    struct Signals {
        bool s[4];
        bool c0, tmp1, and1, and2, c1, c2;
    };

    void simulate(const bool ac[4], const bool x[2], Signals &sig) {
        sig.s[0] = ac[0] ^ x[0];
        sig.c0 = ac[0] & x[0];

        sig.tmp1 = ac[1] ^ x[1];
        sig.s[1] = sig.tmp1 ^ sig.c0;
        sig.and1 = ac[1] & x[1];
        sig.and2 = sig.tmp1 & sig.c0;
        sig.c1 = sig.and1 | sig.and2;

        sig.s[2] = ac[2] ^ sig.c1;
        sig.c2 = ac[2] & sig.c1;

        sig.s[3] = ac[3] ^ sig.c2;
    }

    void printVector(const bool ac[4], const bool x[2]) const {
        for (int i = 3; i >= 0; --i) std::cout << ac[i];
        std::cout << ' ';
        for (int i = 1; i >= 0; --i) std::cout << x[i];
    }
};

class FaultTester {
private:
    const char* signals[10] = {"AC_n[0]", "AC_n[1]", "AC_n[2]", "AC_n[3]", "GEN0_Cout","GEN1_Cout", "GEN2_Cout", "Cout[0]", "Cout[1]", "Cout[2]"};
    bool detectable[20] = {false};
    AdderSimulator sim;

public:
    void listFaults() const {
        std::cout << "Problem 3(a): Total Transition Delay Faults = 20\n";
        std::cout << "List of faults:\n";
        for (int i = 0; i < 10; ++i) {
            std::cout << std::setw(9) <<signals[i] << ':' << std::setw(15) <<" slow-to-rise\n";
            std::cout << std::setw(9) <<signals[i] << ':' << std::setw(15) << " slow-to-fall\n";
        }
        std::cout << '\n';
    }

    void generateS0SlowToRiseTests() {
        std::cout << "Problem 3(b): 2-Pattern Tests for AC_n[0] Slow-to-Rise\n";
        std::cout << "                AC   X        AC   X \n";
        int testCount = 0;
        bool ac1[4], ac2[4], x1[2], x2[2];
        AdderSimulator::Signals s1, s2;

        for (int a = 0; a < 16; ++a) {
            for (int i = 0; i < 4; ++i) ac1[i] = (a >> i) & 1;
            x1[0] = ac1[0]; // S0 = 0
            x2[0] = !ac1[1]; // S0 = 1

            for (int x1_1 = 0; x1_1 < 2; ++x1_1) {
                x1[1] = x1_1;
                for (int x2_1 = 0; x2_1 < 2; ++x2_1) {
                    x2[1] = x2_1;
                    for (int b = 0; b < 2; ++b) {
                        ac2[3] = b;
                        for (int i = 2; i >= 0; --i) ac2[i] = ac1[i + 1];
                        sim.simulate(ac1, x1, s1);
                        sim.simulate(ac2, x2, s2);
                        if (s1.s[0] == 0 && s2.s[0] == 1) {
                            std::cout << "Test " << std::setfill('0')<< std::setw(3) << (++testCount) << ": V1 = ";
                            sim.printVector(ac1, x1);
                            std::cout << ", V2 = ";
                            sim.printVector(ac2, x2);
                            std::cout << '\n';
                        }
                    }
                }
            }
        }
        std::cout << "Total tests for AC_n[0] slow-to-rise: " << testCount << "\n\n";
    }

    void computeFaultCoverage() {
        std::cout << "Problem 3(c): Fault Coverage\n";
        bool ac1[4], ac2[4], x1[2], x2[2];
        AdderSimulator::Signals s1, s2;

        for (int a = 0; a < 16; ++a) {
            for (int i = 0; i < 4; ++i) ac1[i] = (a >> i) & 1;
            for (int i = 0; i < 2; ++i)
                for (int j = 0; j < 2; ++j)
                    for (int k = 0; k < 2; ++k)
                        for (int l = 0; l < 2; ++l)
                            for (int b = 0; b < 2; ++b) {
                                x1[0] = i; x1[1] = j;
                                x2[0] = k; x2[1] = l;
                                ac2[3] = b;
                                for (int m = 2; m >= 0; --m) ac2[m] = ac1[m + 1];

                                sim.simulate(ac1, x1, s1);
                                sim.simulate(ac2, x2, s2);

                                bool v1[10] = {s1.s[0], s1.c0, s1.tmp1, s1.s[1], s1.and1, s1.and2,
                                               s1.c1, s1.s[2], s1.c2, s1.s[3]};
                                bool v2[10] = {s2.s[0], s2.c0, s2.tmp1, s2.s[1], s2.and1, s2.and2,
                                               s2.c1, s2.s[2], s2.c2, s2.s[3]};

                                for (int m = 0; m < 10; ++m) {
                                    // slow-to-rise
                                    if (v1[m] == 0 && v2[m] == 1 && !equalOutputs(s1.s, s2.s))
                                        detectable[2 * m] = true;
                                    // slow-to-fall
                                    if (v1[m] == 1 && v2[m] == 0 && !equalOutputs(s1.s, s2.s))
                                        detectable[2 * m + 1] = true;
                                }
                            }
        }

        int count = 0;
        for (bool f : detectable) if (f) count++;
        float coverage = count / 20.0f * 100;
        std::cout << "Detectable faults: " << count << " out of 20\n";
        std::cout << "Fault coverage: " << std::fixed << std::setprecision(2) << coverage << "%\n";
    }

private:
    bool equalOutputs(const bool a[4], const bool b[4]) const {
        for (int i = 0; i < 4; ++i)
            if (a[i] != b[i]) return false;
        return true;
    }
};

int main() {
    FaultTester tester;
    tester.listFaults();
    tester.generateS0SlowToRiseTests();
    tester.computeFaultCoverage();
    return 0;
}
