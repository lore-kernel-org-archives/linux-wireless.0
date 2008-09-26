Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53292 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYIZVFV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 17:05:21 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KjKUz-0008UE-UJ
	for linux-wireless@vger.kernel.org; Fri, 26 Sep 2008 21:05:13 +0000
Received: from 77.21.175.82 ([77.21.175.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 21:05:13 +0000
Received: from feldmann_markus by 77.21.175.82 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 21:05:13 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: Do not get BCM4303 to work
Date: Fri, 26 Sep 2008 23:07:23 +0200
Message-ID: <gbjipv$cgd$1@ger.gmane.org> (sfid-20080926_230527_952288_997559B8)
References: <ga2fra$9q$1@ger.gmane.org> <48C5777B.9070106@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
In-Reply-To: <48C5777B.9070106@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> feldmaus wrote:
>> Hi All,
>>
>> i do not get my Wlan Card with BCM4303 Chip to work.
>>
>> I am not sure whether this Card is active, because <dmesg> show me,
>> [  409.752921] b43legacy-phy0: Radio hardware status changed to DISA=
BLED
>=20
> Your card can receive, but not transmit due to a problem with the rfk=
ill=20
> switch handling in b43legacy. I'm working on this problem with a Ubun=
tu=20
> user, and will post patches as soon as the problem is fixed.
>=20
> Larry
Hi Larry,

i thought it would be helpful to post my Messages. :-)
If not ignore this Message.:-)

I am using the NetworkManager Applet to show and connect to Wlan Networ=
ks.
My wireless Button shines blue when my Linux System starts.
However after i login onto myGnome Desktop and after some time the=20
NetworkManager Applet shows me my Wireless Network.

dmesg says,
=2E..
[   22.024553] Broadcom 43xx-legacy driver loaded [ Features: PLRID,=20
=46irmware-ID: FW10 ]
=2E..
[   43.384052] b43legacy-phy0: Loading firmware version 0x127, patch
level 14 (2005-04-18 02:36:27)
[   40.776050] b43legacy-phy0: Loading firmware version 0x127, patch=20
level 14 (2005-04-18 02:36:27)
[   40.892896] b43legacy-phy0 debug: Chip initialized
[   40.893291] b43legacy-phy0 debug: 30-bit DMA initialized
[   40.893422] Registered led device: b43legacy-phy0:tx
[   40.901752] Registered led device: b43legacy-phy0:rx
[   40.909982] Registered led device: b43legacy-phy0:radio
[   40.918152] b43legacy-phy0 debug: Wireless interface started
[   40.918159] b43legacy-phy0 debug: Adding Interface type 2
[   40.936417] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   41.300046] b43legacy-phy0: Radio hardware status changed to DISABLE=
D
=2E..


Then i try to connect to this Network by press on my listed Network in
the NetworkManager Applet. Then he connects to the Network. Der Network=
=20
Balken zeigt einen Verbindungsstatus an von 0%.


dmesg says,
[  530.437247] b43legacy-phy0 debug: Removing Interface type 2
[  530.446006] b43legacy-phy0 debug: Wireless interface stopped
[  530.446142] b43legacy-phy0 debug: DMA-30 0x0260 (RX) max used slots:=
 1/64
[  530.446190] b43legacy-phy0 debug: DMA-30 0x0200 (RX) max used slots:=
 1/64
[  530.446245] b43legacy-phy0 debug: DMA-30 0x02A0 (TX) max used slots:=
=20
0/128
[  530.452052] b43legacy-phy0 debug: DMA-30 0x0280 (TX) max used slots:=
=20
0/128
[  530.460038] b43legacy-phy0 debug: DMA-30 0x0260 (TX) max used slots:=
=20
0/128
[  530.468036] b43legacy-phy0 debug: DMA-30 0x0240 (TX) max used slots:=
=20
0/128
[  530.476042] b43legacy-phy0 debug: DMA-30 0x0220 (TX) max used slots:=
=20
2/128
[  530.485144] b43legacy-phy0 debug: DMA-30 0x0200 (TX) max used slots:=
=20
0/128
[  530.492042] b43legacy-phy0 debug: Radio initialized
[  530.492058] b43legacy-phy0 debug: Radio initialized
[  530.506575] input: b43legacy-phy0 as /class/input/input10
[  530.672048] b43legacy-phy0: Loading firmware version 0x127, patch=20
level 14 (2005-04-18 02:36:27)
[  530.824472] b43legacy-phy0 debug: Chip initialized
[  530.824862] b43legacy-phy0 debug: 30-bit DMA initialized
[  530.824993] Registered led device: b43legacy-phy0:tx
[  530.825031] Registered led device: b43legacy-phy0:rx
[  530.825069] Registered led device: b43legacy-phy0:radio
[  530.825102] b43legacy-phy0 debug: Wireless interface started
[  530.825109] b43legacy-phy0 debug: Adding Interface type 3
[  530.846071] wlan0: Trigger new scan to find an IBSS to join
[  531.520050] b43legacy-phy0: Radio hardware status changed to DISABLE=
D
[  531.520431] b43legacy-phy0 debug: Radio initialized
[  531.584041] b43legacy-phy0: Radio turned on by software
[  531.584055] b43legacy-phy0: The hardware RF-kill button still turns=20
the radio physically off. Press the button to turn it on.
[  533.652045] wlan0: Trigger new scan to find an IBSS to join
[  536.428046] wlan0: Trigger new scan to find an IBSS to join
[  539.204045] wlan0: Trigger new scan to find an IBSS to join
[  539.980089] wlan0: Creating new IBSS network, BSSID 96:d6:b6:75:12:4=
a
[  539.980130] wlan0: Configured IBSS beacon template
[  540.928032] wlan0: no IPv6 routers present
[  569.980046] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[  600.756051] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[  612.720029] wlan0: no IPv6 routers present
[  725.457997] wlan0: deauthenticate(reason=3D3)
[  726.477007] b43legacy-phy0 debug: Removing Interface type 3
[  726.492057] b43legacy-phy0 debug: Wireless interface stopped
[  726.492226] b43legacy-phy0 debug: DMA-30 0x0260 (RX) max used slots:=
 1/64
[  726.492272] b43legacy-phy0 debug: DMA-30 0x0200 (RX) max used slots:=
 1/64
[  726.492329] b43legacy-phy0 debug: DMA-30 0x02A0 (TX) max used slots:=
=20
0/128
[  726.500165] b43legacy-phy0 debug: DMA-30 0x0280 (TX) max used slots:=
=20
0/128
[  726.508046] b43legacy-phy0 debug: DMA-30 0x0260 (TX) max used slots:=
=20
0/128
[  726.516038] b43legacy-phy0 debug: DMA-30 0x0240 (TX) max used slots:=
=20
0/128
[  726.524214] b43legacy-phy0 debug: DMA-30 0x0220 (TX) max used slots:=
=20
4/128
[  726.532042] b43legacy-phy0 debug: DMA-30 0x0200 (TX) max used slots:=
=20
0/128
[  726.540054] b43legacy-phy0 debug: Radio initialized
[  726.540069] b43legacy-phy0 debug: Radio initialized
[  726.633096] input: b43legacy-phy0 as /class/input/input11
[  726.796037] b43legacy-phy0: Loading firmware version 0x127, patch=20
level 14 (2005-04-18 02:36:27)
[  726.896786] b43legacy-phy0 debug: Chip initialized
[  726.897036] b43legacy-phy0 debug: 30-bit DMA initialized
[  726.897117] Registered led device: b43legacy-phy0:tx
[  726.897133] Registered led device: b43legacy-phy0:rx
[  726.897149] Registered led device: b43legacy-phy0:radio
[  726.897172] b43legacy-phy0 debug: Wireless interface started
[  726.897175] b43legacy-phy0 debug: Adding Interface type 3
[  727.644031] b43legacy-phy0: Radio hardware status changed to DISABLE=
D
[  727.924601] b43legacy-phy0 debug: Removing Interface type 3
[  727.930047] b43legacy-phy0 debug: Wireless interface stopped
[  727.930129] b43legacy-phy0 debug: DMA-30 0x0260 (RX) max used slots:=
 1/64
[  727.930159] b43legacy-phy0 debug: DMA-30 0x0200 (RX) max used slots:=
 0/64
[  727.930203] b43legacy-phy0 debug: DMA-30 0x02A0 (TX) max used slots:=
=20
0/128
[  727.936037] b43legacy-phy0 debug: DMA-30 0x0280 (TX) max used slots:=
=20
0/128
[  727.944029] b43legacy-phy0 debug: DMA-30 0x0260 (TX) max used slots:=
=20
0/128
[  727.952032] b43legacy-phy0 debug: DMA-30 0x0240 (TX) max used slots:=
=20
0/128
[  727.960033] b43legacy-phy0 debug: DMA-30 0x0220 (TX) max used slots:=
=20
2/128
[  727.968034] b43legacy-phy0 debug: DMA-30 0x0200 (TX) max used slots:=
=20
0/128
[  727.976034] b43legacy-phy0 debug: Radio initialized
[  727.976043] b43legacy-phy0 debug: Radio initialized
[  727.983509] input: b43legacy-phy0 as /class/input/input12
[  728.152040] b43legacy-phy0: Loading firmware version 0x127, patch=20
level 14 (2005-04-18 02:36:27)
[  728.252442] b43legacy-phy0 debug: Chip initialized
[  728.252729] b43legacy-phy0 debug: 30-bit DMA initialized
[  728.252819] Registered led device: b43legacy-phy0:tx
[  728.252839] Registered led device: b43legacy-phy0:rx
[  728.252858] Registered led device: b43legacy-phy0:radio
[  728.252883] b43legacy-phy0 debug: Wireless interface started
[  728.252887] b43legacy-phy0 debug: Adding Interface type 2
[  728.280215] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  728.344731] b43legacy-phy0 debug: Removing Interface type 2
[  728.349895] b43legacy-phy0 debug: Wireless interface stopped
[  728.349978] b43legacy-phy0 debug: DMA-30 0x0260 (RX) max used slots:=
 0/64
[  728.350008] b43legacy-phy0 debug: DMA-30 0x0200 (RX) max used slots:=
 0/64
[  728.350046] b43legacy-phy0 debug: DMA-30 0x02A0 (TX) max used slots:=
=20
0/128
[  728.356050] b43legacy-phy0 debug: DMA-30 0x0280 (TX) max used slots:=
=20
0/128
[  728.364030] b43legacy-phy0 debug: DMA-30 0x0260 (TX) max used slots:=
=20
0/128
[  728.372028] b43legacy-phy0 debug: DMA-30 0x0240 (TX) max used slots:=
=20
0/128
[  728.380028] b43legacy-phy0 debug: DMA-30 0x0220 (TX) max used slots:=
=20
0/128
[  728.388030] b43legacy-phy0 debug: DMA-30 0x0200 (TX) max used slots:=
=20
0/128
[  728.396033] b43legacy-phy0 debug: Radio initialized
[  728.396042] b43legacy-phy0 debug: Radio initialized
[  728.403446] input: b43legacy-phy0 as /class/input/input13
[  728.572043] b43legacy-phy0: Loading firmware version 0x127, patch=20
level 14 (2005-04-18 02:36:27)
[  728.672542] b43legacy-phy0 debug: Chip initialized
[  728.672827] b43legacy-phy0 debug: 30-bit DMA initialized
[  728.672916] Registered led device: b43legacy-phy0:tx
[  728.672937] Registered led device: b43legacy-phy0:rx
[  728.672956] Registered led device: b43legacy-phy0:radio
[  728.672981] b43legacy-phy0 debug: Wireless interface started
[  728.672985] b43legacy-phy0 debug: Adding Interface type 3
[  728.693355] wlan0: Trigger new scan to find an IBSS to join
[  729.416034] b43legacy-phy0: Radio hardware status changed to DISABLE=
D
[  729.416179] b43legacy-phy0 debug: Radio initialized
[  729.500029] b43legacy-phy0: Radio turned on by software
[  729.500037] b43legacy-phy0: The hardware RF-kill button still turns=20
the radio physically off. Press the button to turn it on.
[  731.500116] wlan0: Trigger new scan to find an IBSS to join
[  734.276046] wlan0: Trigger new scan to find an IBSS to join
[  737.052043] wlan0: Trigger new scan to find an IBSS to join
[  737.828087] wlan0: Creating new IBSS network, BSSID f2:00:ad:b6:b3:3=
a
[  737.828128] wlan0: Configured IBSS beacon template
[  738.884029] wlan0: no IPv6 routers present
[  767.828045] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[  798.604045] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[  810.584030] wlan0: no IPv6 routers present
[  994.892048] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1025.668044] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)


ifconfig says,
wlan0     Link encap:Ethernet  Hardware Adresse 00:90:4b:97:34:73
           inet Adresse:169.254.78.197  Bcast:169.254.255.255=20
Maske:255.255.0.0
           inet6-Adresse: fe80::290:4bff:fe97:3473/64=20
G=FCltigkeitsbereich:Verbindung
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metrik:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:179 errors:0 dropped:0 overruns:0 carrier:0
           Kollisionen:0 Sendewarteschlangenl=E4nge:1000
           RX bytes:0 (0.0 B)  TX bytes:32937 (32.1 KiB)


As you can see, some Packets would transmitted over my Wireless Card.


iwconfig says,
wlan0     IEEE 802.11  ESSID:"kleopatra"
           Mode:Ad-Hoc  Frequency:2.412 GHz  Cell: 76:0D:1D:B5:B7:73
           Tx-Power=3D27 dBm
           Retry min limit:7   RTS thr:off   Fragment thr=3D2352 B
           Encryption key:off
           Link Quality:0  Signal level:0  Noise level:0
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

However i can not print to my Wlan Printer and the status in the Networ=
k=20
Manager shows 0%.

Then i pressed my wireless Button, and dmesg says
[ 1056.444034] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1111.004046] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1141.780078] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1172.555792] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1193.449106] phy0: Adding new IBSS station 00:30:6e:d2:4a:99 (dev=3Dw=
lan0)
[ 1212.996048] wlan0: expiring inactive STA 00:30:6e:d2:4a:99
[ 1212.996285] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1243.772044] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1274.548043] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1320.929652] wlan0: deauthenticate(reason=3D3)
[ 1321.952124] b43legacy-phy0 debug: Removing Interface type 3
[ 1321.964039] b43legacy-phy0 debug: Wireless interface stopped
[ 1321.964127] b43legacy-phy0 debug: DMA-30 0x0260 (RX) max used slots:=
 1/64
[ 1321.964160] b43legacy-phy0 debug: DMA-30 0x0200 (RX) max used slots:=
 1/64
[ 1321.964198] b43legacy-phy0 debug: DMA-30 0x02A0 (TX) max used slots:=
=20
0/128
[ 1321.972035] b43legacy-phy0 debug: DMA-30 0x0280 (TX) max used slots:=
=20
0/128
[ 1321.980027] b43legacy-phy0 debug: DMA-30 0x0260 (TX) max used slots:=
=20
0/128
[ 1321.988031] b43legacy-phy0 debug: DMA-30 0x0240 (TX) max used slots:=
=20
0/128
[ 1321.996030] b43legacy-phy0 debug: DMA-30 0x0220 (TX) max used slots:=
=20
4/128
[ 1322.004028] b43legacy-phy0 debug: DMA-30 0x0200 (TX) max used slots:=
=20
0/128
[ 1322.012026] b43legacy-phy0 debug: Radio initialized
[ 1322.012035] b43legacy-phy0 debug: Radio initialized
[ 1322.093411] input: b43legacy-phy0 as /class/input/input14
[ 1322.256079] b43legacy-phy0: Loading firmware version 0x127, patch=20
level 14 (2005-04-18 02:36:27)
[ 1322.356791] b43legacy-phy0 debug: Chip initialized
[ 1322.357047] b43legacy-phy0 debug: 30-bit DMA initialized
[ 1322.357127] Registered led device: b43legacy-phy0:tx
[ 1322.357144] Registered led device: b43legacy-phy0:rx
[ 1322.357160] Registered led device: b43legacy-phy0:radio
[ 1322.357184] b43legacy-phy0 debug: Wireless interface started
[ 1322.357188] b43legacy-phy0 debug: Adding Interface type 3
[ 1323.104036] b43legacy-phy0: Radio hardware status changed to DISABLE=
D
[ 1323.384592] b43legacy-phy0 debug: Removing Interface type 3
[ 1323.396041] b43legacy-phy0 debug: Wireless interface stopped
[ 1323.396150] b43legacy-phy0 debug: DMA-30 0x0260 (RX) max used slots:=
 1/64
[ 1323.396183] b43legacy-phy0 debug: DMA-30 0x0200 (RX) max used slots:=
 0/64
[ 1323.396226] b43legacy-phy0 debug: DMA-30 0x02A0 (TX) max used slots:=
=20
0/128
[ 1323.404039] b43legacy-phy0 debug: DMA-30 0x0280 (TX) max used slots:=
=20
0/128
[ 1323.412026] b43legacy-phy0 debug: DMA-30 0x0260 (TX) max used slots:=
=20
0/128
[ 1323.420026] b43legacy-phy0 debug: DMA-30 0x0240 (TX) max used slots:=
=20
0/128
[ 1323.428031] b43legacy-phy0 debug: DMA-30 0x0220 (TX) max used slots:=
=20
2/128
[ 1323.436034] b43legacy-phy0 debug: DMA-30 0x0200 (TX) max used slots:=
=20
0/128
[ 1323.444032] b43legacy-phy0 debug: Radio initialized
[ 1323.444041] b43legacy-phy0 debug: Radio initialized
[ 1323.454511] input: b43legacy-phy0 as /class/input/input15
[ 1323.620042] b43legacy-phy0: Loading firmware version 0x127, patch=20
level 14 (2005-04-18 02:36:27)
[ 1323.720624] b43legacy-phy0 debug: Chip initialized
[ 1323.720911] b43legacy-phy0 debug: 30-bit DMA initialized
[ 1323.721002] Registered led device: b43legacy-phy0:tx
[ 1323.721024] Registered led device: b43legacy-phy0:rx
[ 1323.721043] Registered led device: b43legacy-phy0:radio
[ 1323.721069] b43legacy-phy0 debug: Wireless interface started
[ 1323.721073] b43legacy-phy0 debug: Adding Interface type 2
[ 1323.748106] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1323.811666] b43legacy-phy0 debug: Removing Interface type 2
[ 1323.817608] b43legacy-phy0 debug: Wireless interface stopped
[ 1323.817690] b43legacy-phy0 debug: DMA-30 0x0260 (RX) max used slots:=
 0/64
[ 1323.817722] b43legacy-phy0 debug: DMA-30 0x0200 (RX) max used slots:=
 0/64
[ 1323.817761] b43legacy-phy0 debug: DMA-30 0x02A0 (TX) max used slots:=
=20
0/128
[ 1323.824041] b43legacy-phy0 debug: DMA-30 0x0280 (TX) max used slots:=
=20
0/128
[ 1323.832037] b43legacy-phy0 debug: DMA-30 0x0260 (TX) max used slots:=
=20
0/128
[ 1323.840033] b43legacy-phy0 debug: DMA-30 0x0240 (TX) max used slots:=
=20
0/128
[ 1323.848029] b43legacy-phy0 debug: DMA-30 0x0220 (TX) max used slots:=
=20
0/128
[ 1323.856035] b43legacy-phy0 debug: DMA-30 0x0200 (TX) max used slots:=
=20
0/128
[ 1323.864839] b43legacy-phy0 debug: Radio initialized
[ 1323.864849] b43legacy-phy0 debug: Radio initialized
[ 1323.872375] input: b43legacy-phy0 as /class/input/input16
[ 1324.040043] b43legacy-phy0: Loading firmware version 0x127, patch=20
level 14 (2005-04-18 02:36:27)
[ 1324.140544] b43legacy-phy0 debug: Chip initialized
[ 1324.140835] b43legacy-phy0 debug: 30-bit DMA initialized
[ 1324.140927] Registered led device: b43legacy-phy0:tx
[ 1324.140948] Registered led device: b43legacy-phy0:rx
[ 1324.140967] Registered led device: b43legacy-phy0:radio
[ 1324.140992] b43legacy-phy0 debug: Wireless interface started
[ 1324.140996] b43legacy-phy0 debug: Adding Interface type 3
[ 1324.161293] wlan0: Trigger new scan to find an IBSS to join
[ 1324.884035] b43legacy-phy0: Radio hardware status changed to DISABLE=
D
[ 1324.884253] b43legacy-phy0 debug: Radio initialized
[ 1324.968031] b43legacy-phy0: Radio turned on by software
[ 1324.968040] b43legacy-phy0: The hardware RF-kill button still turns=20
the radio physically off. Press the button to turn it on.
[ 1326.968047] wlan0: Trigger new scan to find an IBSS to join
[ 1329.744048] wlan0: Trigger new scan to find an IBSS to join
[ 1332.520047] wlan0: Trigger new scan to find an IBSS to join
[ 1333.296087] wlan0: Creating new IBSS network, BSSID 76:0d:1d:b5:b7:7=
3
[ 1333.296126] wlan0: Configured IBSS beacon template
[ 1334.644033] wlan0: no IPv6 routers present
[ 1363.296044] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1394.072046] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1405.964030] wlan0: no IPv6 routers present
[ 1517.772022] phy0: Adding new IBSS station 00:30:6e:d2:4a:99 (dev=3Dw=
lan0)
[ 1517.772037] wlan0: expiring inactive STA 00:30:6e:d2:4a:99
[ 1517.772037] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1574.332043] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1582.205006] phy0: Adding new IBSS station 00:30:6e:d2:4a:99 (dev=3Dw=
lan0)
[ 1605.112054] wlan0: expiring inactive STA 00:30:6e:d2:4a:99
[ 1605.128043] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1635.908058] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)
[ 1666.684045] wlan0: No active IBSS STAs - trying to scan for other=20
IBSS networks with same SSID (merge)

The Mac Adress "00:30:6e:d2:4a:99" is from my wireless Printer

Regards Markus

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
