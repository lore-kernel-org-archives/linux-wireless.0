Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37887 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZEOLK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 07:10:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id D1EFF404BCC0
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 13:10:28 +0200 (CEST)
Date: Fri, 15 May 2009 13:10:28 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: linux-wireless@vger.kernel.org
Subject: Automatic reassociate with AP
Message-ID: <alpine.LSU.2.00.0905151306240.4165@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


when the AP flakes out, or I just appen to be out of range, the kernel 
drops the AP association, as dmesg shows:

wlan0: No ProbeResp from current AP 00:0b:0e:4f:cf:80 - assume out of 
range

Manually rerunning `iwconfig wlan0 essid FooNet channel 11` 
reassociates, but I wonder whether the kernel could not do that itself, 
given that it knows the previous settings like ESSID.

System is a 'Linux OpenWrt [8.09] 2.6.25.17 #3 Wed Feb 18 04:48:29 CST 
2009 mips unknown', with b43.


Jan

