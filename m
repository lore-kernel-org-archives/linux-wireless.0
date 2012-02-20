Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:43073 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752287Ab2BTK7X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 05:59:23 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: ath6kl latest git returns SDIo err -84 at init time
Date: Mon, 20 Feb 2012 12:47:43 +0200
Message-ID: <D945C405928A9949A0F33C69E64A1A3B010BCA73@s-mail.siano-ms.ent> (sfid-20120220_115926_925549_428D76E2)
From: "Ruthy Zaphir" <ruthyz@siano-ms.com>
To: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>
Cc: <ath6kl-devel@qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Kalle,

 I am using a SD45 finger evaluation board & cloned yesterday the latest
 ath6kl git and tested it on my linux laptop(with kernel 2.6.35 but I
also tried with a newer one with linux 3.0 ) that has
 an SDIO slot.

 I am getting the below errors after few first read/write and I am
starving
 to understand what is the cause of it.

 We are building a product with AR6103 integrated and I would like to
 overcome that issue.

 Thanks in advance for any support,

 Hope to get good news :-)
 Ruthy

>
> [39668.250460] mmc0: new SDIO card at address 0001
> [39668.250726] sdio new func 1 vendor 0x271 device 0x301 block
0x800/0x200
> [39668.250814] 4-bit async irq mode enabled
> [39668.357814] rd addr 0x450 buf 0xf5f082d0 len 4 ret 0
> [39668.367833] wr addr 0xff4 buf 0xf5cc0000 len 12 ret 0
> [39668.377722] rd addr 0x450 buf 0xf5f082d0 len 4 ret 0
> [39668.387733] wr addr 0xff4 buf 0xf5cc0000 len 12 ret 0
> [39668.397629] rd addr 0x450 buf 0xf5f082d0 len 4 ret -84
> [39668.407572] ath6kl_sdio: probe of mmc0:0001:1 failed with error -84
