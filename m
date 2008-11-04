Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24510 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYKDAQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 19:16:29 -0500
Message-ID: <20081103191625.4rwqio60gsgs0gso-cebfxv@webmail.spamcop.net> (sfid-20081104_011634_057711_776C53F5)
Date: Mon, 03 Nov 2008 19:16:25 -0500
From: Pavel Roskin <proski@gnu.org>
To: msan <msan@email.it>
Cc: linux-wireless@vger.kernel.org
Subject: Re: problems with ath5k driver.
References: <geiib4$apo$2@ger.gmane.org>
In-Reply-To: <geiib4$apo$2@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting msan <msan@email.it>:

> I have an Esprimo D9500 Fujitsu Semens notebook.
> My lspci reports for wireless card: "06:00.0 Ethernet controller: Atheros
> Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev
> 04)"
> Dmesg says: "ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY:
> 0x70)".

This device is only supported in Linux 2.6.27 and newer.

> When I run "iwlist wlan0 scan" it says:" no scan results".

That's what you would see with older kernels.

> There is any support for AR2425 chip?

Yes.

Next time, please specify versions of the software you are having  
trouble with.

-- 
Regards,
Pavel Roskin
