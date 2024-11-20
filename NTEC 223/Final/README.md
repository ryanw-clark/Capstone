R1# copy running-config tftp
192.168.1.5
R1-Run-Config

S1# copy running-config tftp
192.168.1.5
S1-Run-Config

S2# copy running-config tftp
192.168.1.5
S2-Run-Config

S3# copy tftp: flash:
209.165.202.131
c2960-lanbasek9-mz.150-2.SE4.bin
S3# configure terminal
S3(config)# boot system flash:c2960-lanbasek9-mz.150-2.SE4.bin
S3# exit
S3# copy run start