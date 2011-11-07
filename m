Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:54528 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1KGPPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 10:15:30 -0500
Received: from smtp04.msg.oleane.net (smtp04.mail.priv [172.17.20.113])
	by smtp-out06.msg.oleane.net with ESMTP id pA7FFSOw026154
	for <linux-wireless@vger.kernel.org>; Mon, 7 Nov 2011 16:15:28 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp04.msg.oleane.net (MTA) with ESMTP id pA7EswhS014759
	for <linux-wireless@vger.kernel.org>; Mon, 7 Nov 2011 15:54:59 +0100
Subject: ifconfig down and mac80211 issue
From: voncken <cedric.voncken@acksys.fr>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 15:54:58 +0100
Message-ID: <1320677698.1687.13.camel@voncken-desktop> (sfid-20111107_161533_878983_7E7F3261)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

    I am currently trying to use rstp protocol (using rstpd ) over
wireless interfaces (ath9k) and I've noticed some strange hostapd
behaviour.

    Everything seems to work great with wired Ethernet devices.

    this is what I do : 
	- I have configured an AP (with hostapd), and it works perfectly
(beacons were sent)
    	- ifconfig wlanx down
	- ifconfig wlanx up

    after the ifconfig up, the wlanx does not send any beacons although
clients are perfectly able to associate with (WPA-SUPPLICANT does an
active scan).

    Have you ever encounter such issue ?

    Thanks in advance,

-- 
VONCKEN Cédric
ACKSYS R&D dept



