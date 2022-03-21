#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <arpa/inet.h>

int main()
{
    int s=socket(AF_INET,SOCK_DGRAM,0);
    if (s<0)
    {
        printf("Eraore la crearwa socketului client!\n");
        return 1;
    }
    struct sockaddr_in server;
    memset(&server,0,sizeof(server));
    server.sin_family=AF_INET;
    server.sin_port=htons(8686);
    server.sin_addr.s_addr=inet_addr("127.0.0.1");
    int l=sizeof(server);
    char msg[512];
    int nrminute;
    strcpy(msg,"Asteptam ca serverul sa dea data si ora curenta!");
    sendto(s,msg,strlen(msg)*sizeof(char),MSG_WAITALL,(struct sockaddr*)&server$
    memset(msg,0,512);
    recvfrom(s,&nrminute,sizeof(nrminute),0,(struct sockaddr*)&server,&l);
    nrminute=ntohl(nrminute);
    printf("Numarul de minute trecute de la 1 ianuarie 1990 este=%d\n",nrminute$
    close(s);
    return 0;
}
