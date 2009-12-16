Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:51013 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbZLPCyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 21:54:50 -0500
Received: by pwj9 with SMTP id 9so344392pwj.21
        for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 18:54:48 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 15 Dec 2009 18:54:48 -0800
Message-ID: <aaaa5a4e0912151854q6f8c3466hc947d1af67aabb85@mail.gmail.com>
Subject: Connect Issue to an AP having WPA2-AES authentication using a b4318
	STA
From: "Ravindran, Balaji" <b@w1an.in>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


I had setup a b43xx card on the wireless testing kernel, and was
trying to connect to my AP at home, after having successfully setup
and associated at work place. But i noticed that though my passphrase
was authenticated, i was not able to connect to AP at home.

I did not have issues at work place, where it was OPEN security :).

At home i have WPA2-AES. What could be the issue?

Though i see beacon loss from AP message, my AP is active and i'am
connected to two other STA's on the same SSID.

Additional Info:

1. Running latest wireless-testing kernel

some dmesg logs are below:

[ 1223.404590] b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[ 1223.424278] b43-phy1 debug: Chip initialized
[ 1223.424399] b43-phy1 debug: PIO initialized
[ 1223.424494] b43-phy1 debug: QoS enabled
[ 1223.434224] b43-phy1 debug: Wireless interface started
[ 1223.454398] b43-phy1 debug: Adding Interface type 2
[ 1223.458832] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[ 1224.715229] phy1: device no longer idle - scanning
[ 1226.008427] phy1: device now idle
[ 1226.008708] phy1: device no longer idle - in use
[ 1226.008815] wlan1: direct probe to AP 00:21:29:ae:1d:37 (try 1)
[ 1226.009320] wlan1: direct probe to AP 00:21:29:ae:1d:37 (try 1)
[ 1226.019713] wlan1: direct probe responded
[ 1226.019722] wlan1: authenticate with AP 00:21:29:ae:1d:37 (try 1)
[ 1226.023726] wlan1: authenticated
[ 1226.023857] wlan1: associate with AP 00:21:29:ae:1d:37 (try 1)
[ 1226.026607] wlan1: RX AssocResp from 00:21:29:ae:1d:37 (capab=0x411
status=0 aid=1)
[ 1226.026612] wlan1: associated
[ 1226.026636] phy1: Allocated STA 00:21:29:ae:1d:37
[ 1226.026656] phy1: Inserted STA 00:21:29:ae:1d:37
[ 1226.027690] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[ 1226.030379] b43-phy1 debug: RX: Packet dropped
[ 1228.997378] wlan1: detected beacon loss from AP - sending probe request
[ 1229.497371] No probe response from AP 00:21:29:ae:1d:37 after 500ms, try 1
[ 1229.997312] No probe response from AP 00:21:29:ae:1d:37 after 500ms, try 2
[ 1230.497247] No probe response from AP 00:21:29:ae:1d:37 after 500ms, try 3
[ 1230.997995] No probe response from AP 00:21:29:ae:1d:37 after 500ms, try 4
[ 1231.498304] No probe response from AP 00:21:29:ae:1d:37 after
500ms, disconnecting.
[ 1231.498627] phy1: Removed STA 00:21:29:ae:1d:37
[ 1231.502395] phy1: Destroyed STA 00:21:29:ae:1d:37
[ 1231.502409] phy1: device now idle
[ 1231.603187] phy1: device no longer idle - scanning
[ 1232.895358] wlan1: direct probe to AP 00:21:29:ae:1d:37 (try 1)
[ 1233.095203] wlan1: direct probe to AP 00:21:29:ae:1d:37 (try 2)
[ 1233.295330] wlan1: direct probe to AP 00:21:29:ae:1d:37 (try 3)
[ 1233.495308] wlan1: direct probe to AP 00:21:29:ae:1d:37 timed out
[ 1233.495639] phy1: device now idle
