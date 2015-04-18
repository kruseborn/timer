#include <iostream>
#include <cstdlib>
using namespace std;
int main(int argc, const char * argv[]) {
    int n;
    int sizey, sizex;
    scanf("%i", &n);
    int arr[1000][1000];
    int arr2[1000][1000];
    while(n--) {
        scanf("%i %i", &sizex, &sizey);
        for(int y = 0; y < sizey; y++) {
            for(int x = 0; x < sizex; x++) {
                scanf("%i", &arr[y][x]);
                arr2[y][x] = 0;
            }
        }

        for(int y = 0; y < sizey; y++) {
            for(int x = 0; x < sizex; x++) {
                int xstart = x;
                for(int yy = y; yy < sizey; yy++, xstart=0) {
                    for(int xx = xstart; xx < sizex; xx++) {
                        int diff = abs(xx-x) + abs(yy-y);
                        arr2[y][x]+= arr[yy][xx]*diff;
                        arr2[yy][xx] += arr[y][x]*diff;
                    }
                }
            }
        }

        int min = 100000000;
        for(int y = 0; y < sizey; y++) {
            for(int x = 0; x < sizex; x++) {
                min = std::min(min, arr2[y][x]);
            }
        }
        printf("%i\n", min);
    }
    return 0;
}
