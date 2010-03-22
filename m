Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:42774 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab0CVRHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 13:07:54 -0400
Received: by fxm23 with SMTP id 23so944688fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 10:07:52 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Steven Wheeler <stevenwheel@gmail.com>
Subject: Re: Problems with Netgear WG511v1 PCMCIA
Date: Mon, 22 Mar 2010 18:07:45 +0100
Cc: "'Pavel Roskin'" <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <002a01cac969$b726e8d0$2574ba70$@com> <201003221647.43357.chunkeey@googlemail.com> <000001cac9de$00a868c0$01f93a40$@com>
In-Reply-To: <000001cac9de$00a868c0$01f93a40$@com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Message-Id: <201003221807.45672.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 March 2010 17:37:44 Steven Wheeler wrote:
> OK, from the pictures it appears to be the WG511 V2 or V3, the front and
> back labeling matches the label positions in the V3 pic
> But, an lspci shows that it has the isl3890 chipset
It almost certainly isn't a ISL3890. Because they only
featured in (dual band) APs and early evaluation/development boards.
(But as things usually go, some could have ended up in customer products...)

>From my stash of p54pci hardware only one manufacture bothered to fix the
Chip and PCI ID... (Zcom XG-603). Netgear on the other hand managed to ship
WG511v2 batchs with broken rssi<->dbm conversion parameters.
Therefore, don't be surprised if you see some odd signal readings.

(Note: This bug does not affect range or performance.
Rhe conversion is done in the driver and so far the dBm signal is
only a indicator for the user about signal strength...)
 
> I just downloaded the latest kernel (2.6.33.1), will build this afternoon
> I already have the P%$ firmware for kernels above 2.6.28, so I can test
> Will update later

here is the link: (also has fullmac firmwares)
http://daemonizer.de/prism54/prism54-fw/

Regards,
	Chr
