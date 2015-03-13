#!/bin/bash
#
# Get sample data

mkdir -p example/in

for tcn in 1113517 897563 999566 1454573 1454768 1467255 1382749 557727 317268 1468717 1315153 846979 1040308 896953 1348811 1403469 1017706 1256645 1050478 1465304 1480868 1446365 1002968 647151 1328161 1459964 293946 1482865 1460983 1446365 798588 1006289 1284588 1002659 1460919 1424165 1461747 1029318 1482990 1478761 1481443 815182 1459164 1462776 1029318 1459164 161469 1140134 1461911 1029318 1483154 1463746 1028392 926865 \
1487401 \
1484741 \
1452852 \
1488196 \
1493975 \
1424059 \
1482612 \
1482641 \
1465073 \
997211  \
1482688 \
1479111 \
1482612 \
1482609 \
1358903 \
1482655 \
1482661 \
252788  \
1466488 \
1483076 \
1483121 \
1494440 \
1483196 \
1483409 \
1482656 \
1483611 \
1485960 \
1486026

do
    url="https://evergreen.iisg.nl/opac/extras/oai/biblio?verb=GetRecord&identifier=oai:evergreen.iisg.nl:${tcn}&metadataPrefix=marcxml"
    file="example/in/${tcn}.xml"
    wget -O $file --no-check-certificate $url
    php src/main/php/tcn.php $file
done
