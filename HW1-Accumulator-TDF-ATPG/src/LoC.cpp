#include <iostream>
#include <array>
#include <string>
#include <iomanip>

class Simulator {
public:
    using BitArray4 = std::array<bool, 4>;
    using BitArray2 = std::array<bool, 2>;
    using SignalArray = std::array<bool, 10>;

    void simulate(const BitArray4& ac, const BitArray2& x, BitArray4& s,
                  bool& c0, bool& tmp1, bool& and1, bool& and2, bool& c1, bool& c2) {
        s[0] = ac[0] ^ x[0];
        c0 = ac[0] & x[0];

        tmp1 = ac[1] ^ x[1];
        s[1] = tmp1 ^ c0;
        and1 = ac[1] & x[1];
        and2 = tmp1 & c0;
        c1 = and1 | and2;

        s[2] = ac[2] ^ c1;
        c2 = ac[2] & c1;

        s[3] = ac[3] ^ c2;
    }

    void print_vector(const BitArray4& ac, const BitArray2& x) {
        for (int i = 3; i >= 0; --i) std::cout << ac[i];
        std::cout << " ";
        for (int i = 1; i >= 0; --i) std::cout << x[i];
    }

    void run() {
        std::cout << "Problem 4(a): Total Transition Delay Faults = 20\n";
        std::cout << "List of faults:\n";
        const std::array<std::string, 10> signals = {"AC_n[0]", "AC_n[1]", "AC_n[2]", "AC_n[3]", "GEN0_Cout", 
                                                     "GEN1_Cout", "GEN2_Cout", "Cout[0]", "Cout[1]", "Cout[2]"};
        for (const auto& sig : signals) {
            std::cout << std::setw(9) << sig << ':' << std::setw(15) <<" slow-to-rise\n";
            std::cout << std::setw(9) << sig << ':' << std::setw(15) << " slow-to-fall\n";
        }
        std::cout << "\n";

        std::cout << "Problem 4(b): 2-Pattern Tests for AC_n[0] Slow-to-Rise (LoC)\n";
        std::cout << "               AC   X        AC   X \n";
        int test_count = 0;
        BitArray4 ac1, ac2, s1, s2;
        BitArray2 x1, x2;
        bool c0_1, tmp1_1, and1_1, and2_1, c1_1, c2_1;
        bool c0_2, tmp1_2, and1_2, and2_2, c1_2, c2_2;

        for (int a = 0; a < 16; ++a) {
            for (int i = 0; i < 4; ++i) ac1[i] = (a >> i) & 1;
            for (int x1_0 = 0; x1_0 < 2; ++x1_0) {
                x1[0] = x1_0;
                for (int x1_1 = 0; x1_1 < 2; ++x1_1) {
                    x1[1] = x1_1;
                    simulate(ac1, x1, s1, c0_1, tmp1_1, and1_1, and2_1, c1_1, c2_1);
                    ac2 = s1;
                    for (int x2_0 = 0; x2_0 < 2; ++x2_0) {
                        x2[0] = x2_0;
                        for (int x2_1 = 0; x2_1 < 2; ++x2_1) {
                            x2[1] = x2_1;
                            simulate(ac2, x2, s2, c0_2, tmp1_2, and1_2, and2_2, c1_2, c2_2);
                            if (!s1[0] && s2[0]) {
                                std::cout << "Test " << std::setfill('0') << std::setw(2) << (test_count + 1) << ": V1 = ";
                                print_vector(ac1, x1);
                                std::cout << ", V2 = ";
                                print_vector(ac2, x2);
                                std::cout << "\n";
                                ++test_count;
                            }
                        }
                    }
                }
            }
        }
        std::cout << "Total tests for AC_n[0] slow-to-rise (LoC): " << test_count << "\n\n";

        std::cout << "Problem 4(c): Fault Coverage (LoC)\n";
        std::array<bool, 20> detectable{};
        SignalArray signals_v1{}, signals_v2{};
        int fault_index;

        for (int a = 0; a < 16; ++a) {
            for (int i = 0; i < 4; ++i) ac1[i] = (a >> i) & 1;
            for (int x1_0 = 0; x1_0 < 2; ++x1_0) {
                x1[0] = x1_0;
                for (int x1_1 = 0; x1_1 < 2; ++x1_1) {
                    x1[1] = x1_1;
                    simulate(ac1, x1, s1, c0_1, tmp1_1, and1_1, and2_1, c1_1, c2_1);
                    ac2 = s1;
                    for (int x2_0 = 0; x2_0 < 2; ++x2_0) {
                        x2[0] = x2_0;
                        for (int x2_1 = 0; x2_1 < 2; ++x2_1) {
                            x2[1] = x2_1;
                            simulate(ac2, x2, s2, c0_2, tmp1_2, and1_2, and2_2, c1_2, c2_2);

                            signals_v1 = {s1[0], c0_1, tmp1_1, s1[1], and1_1, and2_1,
                                          c1_1, s1[2], c2_1, s1[3]};
                            signals_v2 = {s2[0], c0_2, tmp1_2, s2[1], and1_2, and2_2,
                                          c1_2, s2[2], c2_2, s2[3]};

                            for (int i = 0; i < 10; ++i) {
                                // STR
                                fault_index = 2 * i;
                                if (!signals_v1[i] && signals_v2[i] && (s1 != s2)) {
                                    detectable[fault_index] = true;
                                }
                                // STF
                                fault_index = 2 * i + 1;
                                if (signals_v1[i] && !signals_v2[i] && (s1 != s2)) {
                                    detectable[fault_index] = true;
                                }
                            }
                        }
                    }
                }
            }
        }

        int detectable_faults = 0;
        for (bool d : detectable) if (d) ++detectable_faults;
        float coverage = static_cast<float>(detectable_faults) / 20.0f * 100.0f;

        std::cout << "Detectable faults (LoC): " << detectable_faults << " out of 20\n";
        std::cout << std::fixed << std::setprecision(2)
                  << "Fault coverage (LoC): " << coverage << "%\n";
        std::cout << "Comparison: LoS fault coverage is 100.00%\n";
        std::cout << "Note: LoC typically has lower coverage than LoS due to functional capture constraints.\n";
    }
};

int main() {
    Simulator sim;
    sim.run();
    return 0;
}
