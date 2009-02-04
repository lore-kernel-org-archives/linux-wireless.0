Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:50507 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZBDXK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:10:56 -0500
Received: from [192.168.1.102] (151.48.37.158) by cp-out12.libero.it (8.5.016.1)
        id 492C05DA096FEF97 for linux-wireless@vger.kernel.org; Thu, 5 Feb 2009 00:10:54 +0100
To: linux-wireless@vger.kernel.org
Subject: ath5k: problems with wireless network data transfer
From: Fabio Rossi <rossi.f@inwind.it>
Date: Thu, 5 Feb 2009 00:10:26 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902050010.27428.rossi.f@inwind.it> (sfid-20090205_001100_536057_568DB3AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using the lastest wireless-testing for connecting to my access point using 
the ath5k driver. There are no problems in associating to the AP.

I have a lot of problems with the connection in the sense that I observe 
frequently no data transfer between the station and the AP (and so Internet). 
During this network inactivity I can't ping the router or the route command 
is stuck for many seconds. During these periods of time (when I can't use the 
network) the station is always associated to the AP.

Basically the problem arises when I observe a stall in a (previously 
initiated) data transfer or I can't open web pages. I'm sure that the 
wireless network is running correctly because I use at the same time a 
second PC working with the p54pci driver. Moreover there are no problems if I 
connect to the router via ethernet cable.

For example, if I ping (during the same period of time) the router from the 
two PCs, I get the following results:

(ath5k based PC)
526 packets transmitted, 366 received, 30% packet loss, time 526508ms
rtt min/avg/max/mdev = 0.896/3.963/223.934/12.986 ms

(p54pci based PC)
525 packets transmitted, 524 received, 0% packet loss, time 526127ms
rtt min/avg/max/mdev = 1.145/8.392/408.565/29.224 ms

Any idea about the problem or how I can debug this situation?

Regards,
Fabio
