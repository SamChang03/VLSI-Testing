#include <iostream>
#include <iomanip>  // for std::setw, std::setfill
using namespace std;

// Turn the decimal number to binary num
void print_binary(int num, int width) {
    for (int i = width - 1; i >= 0; --i) {
        cout << ((num >> i) & 1);
    }
}

int main() {
    int count = 1;
    cout << "     AC[3:0]  X[1:0]  Result[3:0]\n";

    for (long int ac = 0; ac < 4294967296; ac++) {
        for (int x = 0; x < 4; x++) {
            int result = (ac + x) & 0xF; //Keep 4 bits
            cout << "No." 
                 << setfill('0') << setw(2) << count << "  ";
            print_binary(ac, 4);    cout << "     ";
            print_binary(x, 2);     cout << "      ";
            print_binary(result, 4);cout << "\n";
            count++;
        }
    }
    return 0;
}
