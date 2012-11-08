Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moh3-ve1.go2.pl ([193.17.41.30]:33516 "EHLO moh3-ve1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab2KHMYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 07:24:12 -0500
Received: from moh3-ve1.go2.pl (unknown [10.0.0.117])
	by moh3-ve1.go2.pl (Postfix) with ESMTP id 154D7A6A024
	for <linux-wireless@vger.kernel.org>; Thu,  8 Nov 2012 13:24:08 +0100 (CET)
Received: from unknown (unknown [10.0.0.74])
	by moh3-ve1.go2.pl (Postfix) with SMTP
	for <linux-wireless@vger.kernel.org>; Thu,  8 Nov 2012 13:24:08 +0100 (CET)
Message-ID: <509BA46B.40601@o2.pl> (sfid-20121108_132436_459517_01134360)
Date: Thu, 08 Nov 2012 13:24:11 +0100
From: Piotr Kaczorek <kacz0r1984@o2.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: p54pci randomly fails to load on boot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're using miniPCI WiFi cards in our mini-PC's:
00:02.0 Network controller: Intersil Corporation ISL3886 [Prism 
Javelin/Prism Xbow] (rev 01)

OS is Debian Lenny with 'custom' kernel (3.2.24 from kernel.org).

The WiFi cards usually work without problems except that from time to 
time they don't start during the boot up process. Here's what I found in 
logs:
Nov  7 05:12:24 hostname kernel: [   21.323335] ieee80211 phy0: FW rev 
2.13.25.0 - Softmac protocol 5.9
Nov  7 05:12:24 hostname kernel: [   21.323435] ieee80211 phy0: 
cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
Nov  7 05:12:24 hostname kernel: [   22.567542] ieee80211 phy0: Cannot 
boot firmware!
Nov  7 05:12:24 hostname kernel: [   22.567843] p54pci: probe of 
0000:00:02.0 failed with error -110

Anybody got an idea why firmware might not have loaded (and did without 
any changes after next reboot 24hrs later)?
Is this a hardware problem with WiFi card (we had few that didn't work 
at all 'out of the box')? Maybe a problem with 'hard disk' (we are using 
Compact Flash cards)?

regards,
Piotr Kaczorek

