Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:47480 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026Ab0BQEYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 23:24:51 -0500
Received: by ywh6 with SMTP id 6so5251888ywh.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 20:24:50 -0800 (PST)
Message-ID: <4B7B6F90.6020401@lwfinger.net>
Date: Tue, 16 Feb 2010 22:24:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Monnier <monnier@iro.umontreal.ca>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/5] rtl8187se: Modify Kconfig
References: <4b7adc62.wTpAwUAB+btMnNY6%Larry.Finger@lwfinger.net> <jwv3a10k03u.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
In-Reply-To: <jwv3a10k03u.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/16/2010 09:36 PM, Stefan Monnier wrote:
> 
> I'm really happy to see more activity around these cards.  You can add
> in the above text that the card is used in the MSI Wind 100.

The list of make/models is usually restricted to places where the wireless chip
is built into a card by am OEM, or where the chip is embedded in a USB device
where it is not visible. I suspect the MSI Wind 100 uses a Realtek-built PCIe
card, the same way that my HP laptop came with a Broadcom BCM4312.

> Please let me know if/when you need testers for it (the staging version
> of the driver suffers from stability issues for me, so I'm eager to see
> it replaced).

I certainly will let you know. When the driver is ready for testing, it will be
in the source code of the wireless-testing git tree. In the next merge cycle
(probably for 2.6.35), it will be in the -rcX cycles of mainline, and finally in
the mainline kernel. You can test at any step of the way. When the mainline
driver is merges, the staging driver will be removed.

What are the details of your setup? What signal and noise levels are shown by
iwconfig? What distance are you from the AP, and how much interference is on
your channel? The reason I am asking is that I find the staging driver to be
very stable. It never disconnects unless I bump the RF switch.

Larry

