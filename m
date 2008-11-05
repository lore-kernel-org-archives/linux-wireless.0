Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:50346 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071AbYKEVM2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 16:12:28 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Kxpfq-0004iv-6C
	for linux-wireless@vger.kernel.org; Wed, 05 Nov 2008 21:12:22 +0000
Received: from host251-18-dynamic.51-82-r.retail.telecomitalia.it ([82.51.18.251])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 21:12:22 +0000
Received: from msan by host251-18-dynamic.51-82-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 21:12:22 +0000
To: linux-wireless@vger.kernel.org
From: msan <msan@email.it>
Subject: Re: problems with ath5k driver.
Date: Wed, 5 Nov 2008 21:12:14 +0000 (UTC)
Message-ID: <get27e$ka2$1@ger.gmane.org> (sfid-20081105_221245_810387_1D5F83C1)
References: <geiib4$apo$2@ger.gmane.org>
	<20081103191625.4rwqio60gsgs0gso-cebfxv@webmail.spamcop.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il Mon, 03 Nov 2008 19:16:25 -0500, Pavel Roskin ha scritto:

> Quoting msan <msan@email.it>:
> 
>> I have an Esprimo D9500 Fujitsu Semens notebook. My lspci reports for
>> wireless card: "06:00.0 Ethernet controller: Atheros Communications
>> Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 04)"
>> Dmesg says: "ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY:
>> 0x70)".
> 
> This device is only supported in Linux 2.6.27 and newer.

Now I've installed debian package for Linux 2.6.27 taken from http://
kernel-archive.buildserver.net/debian-kernel/pool/main/l/linux-2.6/
and I have the same message from kernel:

"ath5k phy0: Support for RF2425 is under development."

So it doesn't work even with linux 2.6.27.


