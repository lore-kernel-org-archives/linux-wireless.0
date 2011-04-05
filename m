Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp30.kymp.net ([80.248.96.181]:43603 "EHLO smtp.kymp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab1DEMZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 08:25:28 -0400
Received: from [192.168.0.225] (unknown [77.109.206.88])
	by poseidon.kymp.local (Postfix) with ESMTP id 37C3BC0051
	for <linux-wireless@vger.kernel.org>; Tue,  5 Apr 2011 15:15:12 +0300 (EEST)
Message-ID: <4D9B077E.3090106@saunalahti.fi>
Date: Tue, 05 Apr 2011 15:13:50 +0300
From: Kimmo Huoso <kimmo.huoso@saunalahti.fi>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 7d1:3c10 D-Link System DWA-160 Xtreme N Dual Band USB Adapter(rev.A)
 [Atheros AR9001U-(2)NG] Invalid misc and Tx excessive retries
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Im having vast amount of  Invalid misc, Tx excessive retries. my 
hardware is 7d1:3c10 D-Link System DWA-160 Xtreme N Dual Band USB 
Adapter(rev.A) [Atheros AR9001U-(2)NG]. Kernel is currently kernel26 
2.6.37.5-1 (arch linux x86_64), using carl9170-fw-1.9.2, wpa_supplicant  
0.7.3-3 (arch linux) and driver is now from compat-wireless-2011-03-31.

There seems to be  no difference with latest bleeding edge release of 
linux-wireless either which version of carl9170-fw im using. The problem 
has been there since i were able to compile compat-wireless for 2.6.37 
which i cant recall when. The problems appears either way, ht disabled 
or enabled. Tried to do some "debugging" by enabling 
CONFIG_MAC80211_HT_DEBUG=y....etc switches from the kernel but nothing 
strange seems to appear in dmesg. I never had this problem with 
ar9170usb driver for a note, so i think its not hardware problem exact.


