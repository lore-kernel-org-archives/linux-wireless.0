Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42501 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaKBPXa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2014 10:23:30 -0500
Received: by mail-wi0-f181.google.com with SMTP id n3so4578304wiv.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2014 07:23:28 -0800 (PST)
Message-ID: <54564C6E.6010904@gmail.com> (sfid-20141102_162333_751764_FBD0CAA5)
Date: Sun, 02 Nov 2014 16:23:26 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] Ralink RT3070(rt2800usb) - The Tortoise and the
 Hare
References: <5455C833.2080706@gmail.com> <20141102130003.GA10104@redhat.com>
In-Reply-To: <20141102130003.GA10104@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02.11.2014 14:00, Stanislaw Gruszka wrote:
> On Sun, Nov 02, 2014 at 06:59:15AM +0100, poma wrote:
>> Higher values, are they even possible via rt2800usb.ko & Co.?
> 
> Yes.
> 
>> ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 3070, rev 0201 detected
>> ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0005 detected
> 
> On the same RT and RF chipsets with TP-link WR-1043ND access point I have:
> 
> # iperf -c 192.168.1.105 -i 1
> ------------------------------------------------------------
> Client connecting to 192.168.1.105, TCP port 5001
> TCP window size: 45.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.100 port 56993 connected with 192.168.1.105 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0- 1.0 sec  4.75 MBytes  39.8 Mbits/sec
> [  3]  1.0- 2.0 sec  8.12 MBytes  68.2 Mbits/sec
> [  3]  2.0- 3.0 sec  8.00 MBytes  67.1 Mbits/sec
> [  3]  3.0- 4.0 sec  8.75 MBytes  73.4 Mbits/sec
> [  3]  4.0- 5.0 sec  7.00 MBytes  58.7 Mbits/sec
> [  3]  5.0- 6.0 sec  9.00 MBytes  75.5 Mbits/sec
> [  3]  6.0- 7.0 sec  8.25 MBytes  69.2 Mbits/sec
> [  3]  7.0- 8.0 sec  7.75 MBytes  65.0 Mbits/sec
> [  3]  8.0- 9.0 sec  8.75 MBytes  73.4 Mbits/sec
> [  3]  9.0-10.0 sec  7.75 MBytes  65.0 Mbits/sec
> [  3]  0.0-10.0 sec  78.2 MBytes  65.5 Mbits/sec
> 
> Stanislaw
> 

For you this are the solid results?

One would expect a little more detail from you, man. :)

Care to share what are AP's:
- hardware revision
- firmware
- basic and advanced wireless settings


DD-WRT
http://www.dd-wrt.com/wiki/index.php/Supported_Devices_802.11n#TP-Link

- Model                      : WR1043N(D)
- H.W.                       : v1.1/4/5
- Platform & Frequency [MHz] : AR9132 @ 400
- RAM [MB]                   : 32
- Flash Mem. [MB]            : 8
- Wireless NIC               : Atheros ar9103 3x3 MIMO
- WLAN standard [802.11]     : b/g/n
- Serial port                : 1
- JTAG port                  : 1
- Eth. port count            : 1 Gbit WAN 4 Gbit LAN
- Volt. Input [V/A]          : 12V 1.5A
- Special Features notes     : USB
- min required DD-WRT version: WR1043ND v.24 SP2 - build 13972 - 20100223
- Notes for Running DD-WRT   : N clients connect only at G tx/rx rate, 
                               everything else working


OpenWrt
http://wiki.openwrt.org/toh/tp-link/tl-wr1043nd
TP-Link TL-WR1043ND

- HW Version: 1.x                      : 2.x                  
- CPU       : Atheros AR9132 @ 400MHz  : Qualcomm Atheros QCA9558 @ 720MHz
- Ram       : 32 MB                    : 64 MB
- Flash     :  8 MB                    :  8 MB
- Network   : 4x1                      : 4x1
- Gigabit   : Yes                      : Yes
- USB       : Yes                      : Yes
- Serial    : Yes                      : Yes
- JTag      : Yes                      : No


Gargoyle
http://www.gargoyle-router.com/wiki/doku.php?id=supported_routers_-_tested_routers
TP-Link TL-WR1043ND v1-1.8


TP-LINK
http://www.tp-link.com/en/products/details/?model=TL-WR1043ND


poma

