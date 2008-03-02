Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:31486 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYCBLT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 06:19:57 -0500
Received: by el-out-1112.google.com with SMTP id v27so1038722ele.17
        for <linux-wireless@vger.kernel.org>; Sun, 02 Mar 2008 03:19:56 -0800 (PST)
Message-ID: <646765f40803020319mf2db1fg9b9a1dde58fcda62@mail.gmail.com> (sfid-20080302_112001_009527_4298B19F)
Date: Sun, 2 Mar 2008 22:19:54 +1100
From: "Julian Calaby" <julian.calaby@gmail.com>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Netgear WG311v3 - Marvell 88w8355 "Libertas"
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm not sure if this is the correct place to ask this, but here goes.

I have recently obtained a Netgear WG311v3 card, under the
misunderstanding that it was an atheros card. (though I have no idea
how I managed to do that)

Following some random FAQ, I have this card working reliably, for the
moment, using ndiswrapper, which is more than suitable for my needs.

However I yearn for more.

I have discovered here:
http://users.linpro.no/janl/hardware/wifi.html
that this card appears to use a Marvel 88w8355 "Libertas" chipset.
However I have not yet confirmed the exact chip used on my card.

I believe variants of this chip, are supported on SDIO, (8385, 8686)
USB (8388) and CompactFlash (8385) using the libertas driver.

Annoyingly I can find no information on this chip, or anything related
to it, and I have heard that Marvel has been relatively uninterested
in supporting these chips on Linux.

I also note that this chip appears to have been designed exclusively
for the embedded market, and as such, my card is somewhat rare, which
has probably contributed to the lack of any interest in a pci driver.

I can also find no information on a pci version of the libertas
driver, only a proposal which appeared to go nowhere due to lack of
documentation. I also cannot find any information on any linux support
for this card outside of using ndiswrapper.

As such, I am considering reverse engineering the pci interface for
this chipset, and hopefully linking it up with the existing libertas
driver.

I was hoping to use the ndiswrapper driver as a starting point, using
it as a black box to see how it talks to the PCI card. (possibly
hacking together a OS level PCI sniffer) and hopefully, what I'll see
will match up to what's going on in the libertas driver for similar
tasks, and then I should be able to write the necessary code (or
specifications) to do this.

I am also concerned about any possible legal ramifications of this
reverse engineering. Is it all right for me to do this, providing that
I treat the ndiswrapper driver as a black box? or am I too close to
non-free code to have my code be untainted?

I also must point out that this will be my first reverse engineering
project of this scale, and I am inexperienced in linux drivers in
general - however I see it as a good way to learn.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
