Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:60038 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959Ab0BQFl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 00:41:27 -0500
From: Stefan Monnier <monnier@iro.umontreal.ca>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/5] rtl8187se: Modify Kconfig
Message-ID: <jwvljesig8x.fsf-monnier+inbox@gnu.org>
References: <4b7adc62.wTpAwUAB+btMnNY6%Larry.Finger@lwfinger.net>
	<jwv3a10k03u.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	<4B7B6F90.6020401@lwfinger.net>
Date: Wed, 17 Feb 2010 00:30:57 -0500
In-Reply-To: <4B7B6F90.6020401@lwfinger.net> (Larry Finger's message of "Tue,
	16 Feb 2010 22:24:48 -0600")
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The list of make/models is usually restricted to places where the
> wireless chip is built into a card by am OEM, or where the chip is
> embedded in a USB device where it is not visible. I suspect the MSI
> Wind 100 uses a Realtek-built PCIe card, the same way that my HP
> laptop came with a Broadcom BCM4312.

I see, thanks.

>> Please let me know if/when you need testers for it (the staging version
>> of the driver suffers from stability issues for me, so I'm eager to see
>> it replaced).
> I certainly will let you know. When the driver is ready for testing,
> it will be in the source code of the wireless-testing git tree.

Great, so I'll be waiting for it there.

> What are the details of your setup? What signal and noise levels are shown by
> iwconfig? What distance are you from the AP, and how much interference is on
> your channel? The reason I am asking is that I find the staging driver to be
> very stable. It never disconnects unless I bump the RF switch.

Yes, the connection is stable once it's setup, but I get system hangs
when I switch from one SSID to another.


        Stefan
