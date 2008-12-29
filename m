Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa001msb.fastweb.it ([85.18.95.80]:36962 "EHLO
	aa001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbYL2MSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 07:18:53 -0500
Received: from [192.168.1.101] (39.234.158.229) by aa001msb.fastweb.it (8.0.013.8)
        id 4946859B02AA1D5D for linux-wireless@vger.kernel.org; Mon, 29 Dec 2008 13:18:51 +0100
Message-ID: <4958C029.7000407@techemia.com> (sfid-20081229_131857_891751_B4C65E32)
Date: Mon, 29 Dec 2008 13:18:49 +0100
From: techmin <info@techemia.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: problem on gelic ps3 driver 2.25.2 kernel (used with psubuntu)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If i configure network with tool, the icon show 100% connection (and it 
is not possible, maximum is 50% cause the distance to acces point), 
wireless is protect (i use wep) but the led not blinck, simply is on. 
But ping not work, and is not possible to navigate on the web.
If i configure directly from /etc/network/interfaces (with all 
network-manager disabled) same problem.
If i use simple script to manually pass the iwconfig and ifconfig 
command same proble.
If i not use protection same problem.

If i set manage mode:
managed mode is not set, operation not permitted

iwlist scan work.
Note: in iwconfig not appear the channel and if i add manually the 
channel with iwconfig wlan0 channel numder i have error: operation not 
permitted.

syslog don't have any entry
only error is this:
gelic_eurus_sync_cmd_worker: cmd issue failed

gelic use bss, is possible a problem on set the mode and the channel?
