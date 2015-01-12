Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eir.turningtechnologies.com ([208.81.149.60]:52564 "EHLO
	eir.turningtechnologies.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbbALTpd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 14:45:33 -0500
From: Larry Harmon <lharmon@turningtechnologies.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mwl8k txpower help? NEWBIE
Date: Mon, 12 Jan 2015 19:45:31 +0000
Message-ID: <78A47A9F25224F4785BDE100564E22AB6F3459EE@Thrud.TurningTechnologies.local> (sfid-20150112_204540_321974_ADF5DC2C)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is my first post, so be gentle...


I am trying to learn how to control the tx power of my access point.

After my system is up and running I attempt to lower the txpower using "iwconfig wlp1s0 txpower 15"
The system accepts the command without complaint and a subsequent iwconfig wlp1s0 command yields:
wlp1s0    IEEE 802.11abgn  Mode:Master  Tx-Power=15 dBm
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:on


However,  monitoring the airwaves with "inSSIDer" (Windows) or the Android "Wi-Fi Analyzer"  I see no drop in measured output power.

What am I doing wrong??

More Info:

I am running a GTI SmilePLUG - a Marvell Armada-370  with a Marvell 88w8764 PCIe module.
Distro is ArchlinuxARM
Kernel is 3.18.1
Driver - b Marvell TOPDOG(R) 802.11 Wireless Network Driver version 0.13
Firmware - ieee80211 phy0: 88w8764 v7, 30144ad8e0b3, AP firmware 7.4.0.9

Systemd and system.network are used for system initialization and network startup

iwconfig wlp1s0
wlp1s0    IEEE 802.11abgn  Mode:Master  Tx-Power=15 dBm
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:on



Regards,

Larry Harmon
 
