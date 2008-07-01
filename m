Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49012 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYGAQqF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 12:46:05 -0400
Date: Tue, 1 Jul 2008 19:45:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: linux-next: manual merge of the ttydev tree
Message-ID: <20080701164545.GD32598@cs181140183.pp.htv.fi> (sfid-20080701_184621_297328_EC388842)
References: <20080702000712.3698a7f9.sfr@canb.auug.org.au> <20080701151205.2b728f94@lxorguk.ukuu.org.uk> <20080701144330.GA32598@cs181140183.pp.htv.fi> <20080701164220.18bba393@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20080701164220.18bba393@lxorguk.ukuu.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 01, 2008 at 04:42:20PM +0100, Alan Cox wrote:
> > When we discussed the removal of the driver we weren't able to find any 
> > realistic chance that people both have this hardware and this kind of 
> > wireless network.
> > 
> > What users do you know about?
> 
> The modems worked both with base stations but they also support working
> as an adhoc star mode network and yes - people still use them for that in
> interesting places where 802.11 doesn't work nicely. And I got bug
> reports.. You can still plug em into a PC today and build ad-hoc star
> networks including funky stuff like dual modem full dupex.
> 
> Of course if you'd bothered to discuss it anywhere I can find or read you
> might have found that out earlier.

It was discussed on linux-wireless which seems to be the appropriate 
place for a driver under drivers/net/wireless/

If you consider yourself the maintainer of this driver, can you dump 
the non-working URL from the MAINTAINERS entry (whose removal was my 
original patch) and add yourself instead?

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

