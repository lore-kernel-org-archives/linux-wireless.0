Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from col0-omc2-s14.col0.hotmail.com ([65.55.34.88]:5826 "EHLO
	col0-omc2-s14.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450AbZDSJmn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 05:42:43 -0400
Message-ID: <COL102-W39E2B31099B7B204D6F8B0AC790@phx.gbl> (sfid-20090419_114248_701872_C4249EFE)
From: Florian Dorpmueller <dorpmueller@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: Allnet 0271 not working with 2.13.1.0.arm
Date: Sun, 19 Apr 2009 09:36:31 +0000
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


In Ubuntu Jaunty my Allnet 0271 does not work with the actual released firmware.

http://daemonizer.de/prism54/prism54-fw/fw-softmac/2.13.1.0.arm

In dmesg I see:

[    9.663580] p54: unknown eeprom code : 0x1

[    9.663582] p54: unknown eeprom code : 0x1007

[    9.663584] p54: unknown eeprom code : 0x1008

[    9.663585] p54: unknown eeprom code : 0x1100

[    9.663586] p54: unknown eeprom code : 0x1905

[    9.663590] p54: unknown eeprom code : 0x3

[    9.663593] phy0: hwaddr 00:01:36:07:12:19, MAC:isl3890 RF:Frisbee

[    9.664613] phy0: Selected rate control algorithm 'pid'

[    9.873686] lp0: using parport0 (interrupt-driven).

[    9.951877] Adding 7815580k swap on /dev/sda5.  Priority:-1 extents:1 across:7815580k

[    9.957601] EXT3 FS on sda1, internal journal

[   10.844158] kjournald starting.  Commit interval 5 seconds

[   10.844386] EXT3 FS on sda6, internal journal

[   10.844390] EXT3-fs: mounted filesystem with ordered data mode.

[   10.876539] kjournald starting.  Commit interval 5 seconds

[   10.876546] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended

[   10.876853] EXT3 FS on sdb1, internal journal

[   10.876857] EXT3-fs: mounted filesystem with ordered data mode.

[   11.162273] type=1505 audit(1240090836.182:2): operation="profile_load" name="/sbin/dhclient-script" name2="default" pid=2097

[   11.162382] type=1505 audit(1240090836.182:3): operation="profile_load" name="/sbin/dhclient3" name2="default" pid=2097

[   11.162419] type=1505 audit(1240090836.182:4): operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default" pid=2097

[   11.162452] type=1505 audit(1240090836.182:5): operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" name2="default" pid=2097

[   11.266592] type=1505 audit(1240090836.286:6): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=2102

[   11.266734] type=1505 audit(1240090836.286:7): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=2102

[   11.288876] type=1505 audit(1240090836.306:8): operation="profile_load" name="/usr/sbin/mysqld-akonadi" name2="default" pid=2106

[   11.324521] type=1505 audit(1240090836.342:9): operation="profile_load" name="/usr/sbin/tcpdump" name2="default" pid=2110

[   11.722252] RPC: Registered udp transport module.

[   11.722254] RPC: Registered tcp transport module.

[   11.809681] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).

[   14.721182] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory

[   14.735435] NFSD: starting 90-second grace period

[   15.018011] p54pci 0000:01:0a.0: firmware: requesting isl3886

[   15.146747] ADDRCONF(NETDEV_UP): wlan0: link is not ready

[   15.653030] phy0: tx overflow.

[   15.713028] phy0: tx overflow.

[   15.713036] phy0: tx overflow.

[   15.773022] phy0: tx overflow.

[   15.773030] phy0: tx overflow.lspci -k | grep -A3 "Network controller" gives me:
01:0a.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
        Kernel driver in use: p54pci
        Kernel modules: p54pci, prism54
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)


After downgrading the firmware to 2.7.0.0.arm my network device came back into service!!!


I have also passed this information to https://bugs.launchpad.net/ubuntu/+bug/363528 but maybe here it is the better place. if any more information is required please let me know.

Greets,
Florian

_________________________________________________________________
http://redirect.gimas.net/?n=M0904xWLCalendar2
Keinen Termin mehr verpassen! Mit Windows Live Kalender.