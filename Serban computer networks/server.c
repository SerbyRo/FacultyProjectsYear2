#include <time.h>
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
        printf("Eroare la crearea soccketului server!\n");
        return 1;
    }
    struct sockaddr_in server,client;
    int l=sizeof(server);
    memset(&server,0,sizeof(server));
    server.sin_family=AF_INET;
    server.sin_port=htons(8686);
    server.sin_addr.s_addr=INADDR_ANY;
    if (bind(s,(struct sockaddr*)&server,sizeof(server))<0)
    {
        printf("Eroare la bind!\n");
        return 1;
    }
    memset(&client,0,sizeof(client));
    time_t timecur;
    while(1)
    {
        char msg[512];
        recvfrom(s,msg,512*sizeof(char),MSG_WAITALL,(struct sockaddr*)&client,&$
        printf("Mesajul este %s\n",msg);
        memset(msg,0,512);
        time(&timecur);
        printf("Data curenta este: %s",ctime(&timecur));
    }
    time_t datainitiala;
    datainitiala=time(NULL); 
double nrseconds=difftime(timecur,datainitiala);
    printf("Numarul de secunde este=%f\n",nrseconds);
    double nrminute=nrseconds/60;
    nrminute=htonl(nrminute);
    nrminute=nrminute-10512000;
    printf("Numarul e minute este=%f\n",nrminute);
    nrminute=htonl(nrminute);
    sendto(s,&nrminute,sizeof(nrminute),0,(struct sockaddr*)&client,l);
    close(s);
    return 0;
}

	