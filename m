Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:2143 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaFQKUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 06:20:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <drwho@infidigm.net>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: QCA ar9375 in Ubuntu 14.04 beta 2 not working
References: <3b045ae380adf4cae45a6e7cd1741ba6.squirrel@www.infidigm.net>
Date: Tue, 17 Jun 2014 13:20:21 +0300
In-Reply-To: <3b045ae380adf4cae45a6e7cd1741ba6.squirrel@www.infidigm.net>
	(drwho@infidigm.net's message of "Wed, 9 Apr 2014 11:27:48 -0400")
Message-ID: <87bntrdehm.fsf@kamboji.qca.qualcomm.com> (sfid-20140617_122102_556106_A0183A5F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

replying to a mail from two months back:

drwho@infidigm.net writes:

> I just got a UB134C which has a QCA ar9375.  I tried it in Ubuntu 14.04
> beta 2 kernel =
> 3.13.0-22-generic #44-Ubuntu SMP Wed Apr 2 20:04:41 UTC 2014 i686
>
> I'm told the 9375 is an ath6kl, but it doesn't look like the ath6kl driver
> supports it.  kernel output.....
>
> new high-speed USB device number 4 using ehci-pci
> [175257.129911] usb 1-2: New USB device found, idVendor=0cf3, idProduct=9375
> [175257.129923] usb 1-2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [175257.129931] usb 1-2: Product: USBWLAN
> [175257.129939] usb 1-2: Manufacturer: Qualcomm Atheros.
> [175257.129946] usb 1-2: SerialNumber: 12345678

I just sent patches to add ar6004 hw3.0 support. If you can, please test
those and give feedback.

http://lists.infradead.org/pipermail/ath6kl/2014-June/000032.html

-- 
Kalle Valo
