Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.spirent.com ([38.111.148.215]:33918 "EHLO
	webmail.spirent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867AbaDBV0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 17:26:50 -0400
From: "Shu, Nick" <Nick.Shu@spirent.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: iw scan command failed
Date: Wed, 2 Apr 2014 21:26:49 +0000
Message-ID: <153F35912E69C446A72CF7D6417EBADE7CF1C4@SPCCOREXCMBX01.AD.SPIRENTCOM.COM> (sfid-20140402_232654_135019_770B9FBD)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, All:
Got an issue when using "iw" to configure my WIFI card.
Issued a scan command and got a "command failed, operation not permitted"
Then changed to root as somebody suggested to do it again, it got worse and said network down. See below for screen capture:

spirent@coast198:~$ iw dev wlan0 scan
command failed: Operation not permitted (-1)
spirent@coast198:~$ su
Password:
root@coast198:/home/spirent# iw dev wlan0 scan
command failed: Network is down (-100)

System set up:
Running Ubuntu 13.10 server version, using a mini PCIe card with QCA9880 chip (ath10k driver should be in 3.11 kernel release).

Can somebody tell me what's wrong?

Thank you!

Nick Shu



E-mail confidentiality.
--------------------------------
This e-mail contains confidential and / or privileged information belonging to Spirent Communications plc, its affiliates and / or subsidiaries. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution and / or the taking of any action based upon reliance on the contents of this transmission is strictly forbidden. If you have received this message in error please notify the sender by return e-mail and delete it from your system.

Spirent Communications plc
Northwood Park, Gatwick Road, Crawley, West Sussex, RH10 9XN, United Kingdom.
Tel No. +44 (0) 1293 767676
Fax No. +44 (0) 1293 767677

Registered in England Number 470893
Registered at Northwood Park, Gatwick Road, Crawley, West Sussex, RH10 9XN, United Kingdom.

Or if within the US,

Spirent Communications,
26750 Agoura Road, Calabasas, CA, 91302, USA.
Tel No. 1-818-676- 2300
