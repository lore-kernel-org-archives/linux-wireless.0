Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:44215 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab2IZKe0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 06:34:26 -0400
Received: from localhost
	([127.0.0.1] helo=purkki.adurom.net ident=kvalo)
	by purkki.adurom.net with esmtp (Exim 4.72)
	(envelope-from <kvalo@adurom.com>)
	id 1TGowj-0001pL-N3
	for linux-wireless@vger.kernel.org; Wed, 26 Sep 2012 13:34:25 +0300
From: Kalle Valo <kvalo@adurom.com>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi: 11n broken with 6300
Date: Wed, 26 Sep 2012 13:34:25 +0300
Message-ID: <87vcf12hu6.fsf@purkki.adurom.net> (sfid-20120926_123429_951225_729FEFEE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have Intel 6300 on my laptop:

02:00.0 Network controller [0280]: Intel Corporation Centrino Ultimate-N
6300 [8086:4238] (rev 35)

And since I have had this laptop (1,5 years now) I have had to disable
11n (11n_disable=1) to get stable wifi, otherwise the TCP connections
would stall or get really slow. I have been hoping to properly debug
this at some point but, as usual, never found the time for it.

But today I noticed that this is still a very common problem:

https://plus.google.com/u/0/100920064738447422284/posts/Q32wEwyumdC

Does anyone know what's causing this? Is this bug (or bugs) tracked anywhere?

My AP is Netgear WNDR3700 running openwrt (10.03, r25221) and ath9k.
Laptop is Lenovo x201 running Ubuntu 12.04.1 64 bit with various
different kernels.

-- 
Kalle Valo
