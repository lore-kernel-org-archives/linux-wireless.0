Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:48820 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYBFLS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 06:18:59 -0500
Date: Wed, 6 Feb 2008 11:45:13 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [RFT 1/1] single_chip test
Message-ID: <20080206104513.GA12496@eazy.amigager.de> (sfid-20080206_111903_763935_39126AFB)
References: <20080206014131.9d489a34.akpm@linux-foundation.org> <1202294560-7313-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1202294560-7313-1-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2008 at 11:42:40 +0100, Jiri Slaby wrote:
> On 02/05/2008 11:57 PM, Tino Keitel wrote:
> > Hi,
> > 
> > I tried the current git (9ef9dc69d4167276c04590d67ee55de8380bc1ad) and
> > got the following error message from ath5k:
> > 
> > ath5k_pci 0000:02:00.0: registered as 'phy0'
> > ath5k phy0: failed to resume the MAC Chip
> > ath5k_pci: probe of 0000:02:00.0 failed with error -5
> 
> We failed to resume after a hardware reset here for a whole second. Is there any 
> version of ath5k which worked for you (is this a regression)?

No, this was my first try with ath5k.

> I suspect ath5k_hw_nic_wakeup being called before setting ah_single_chip in 
> ath5k_hw_attach. Could you test the attached patch?

Thanks, I'll try the patch this evening.

Regards,
Tino
