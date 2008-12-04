Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55597 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbYLDCgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 21:36:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 18:36:31 -0800
Date: Wed, 3 Dec 2008 18:36:29 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: pat-lkml <pat-lkml@erley.org>
CC: Henning Rogge <hrogge@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Looking for a 802.11n card
Message-ID: <20081204023629.GV6522@tesla> (sfid-20081204_033635_369251_B3EE6075)
References: <200812032129.16740.hrogge@googlemail.com> <45e8e6c40812031609h50926100xfa616a5bdb9be93e@mail.gmail.com> <49372568.2070404@erley.org> <20081204023512.GU6522@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20081204023512.GU6522@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 03, 2008 at 06:35:12PM -0800, Luis Rodriguez wrote:
> On Wed, Dec 03, 2008 at 04:33:44PM -0800, pat-lkml wrote:
> > Andrey Yurovsky wrote:
> > > There are a number of options listed here:
> > > http://linuxwireless.org/en/users/Drivers/ath9k#supportedchips
> > >
> > > On Wed, Dec 3, 2008 at 12:29 PM, Henning Rogge <hrogge@googlemail.com> wrote:
> > >> Hi,
> > >>
> > >> I'm looking for a dualband (2,4 Ghz and 5 Ghz) 802.11n card for my desktop,
> > >> but was unable to find one. Can you suggest a good card for testing 802.11n
> > >> with Linux ?
> > >>
> > >> Henning Rogge
> > >>
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > Specifically:
> >
> > AR5418+AR5133 [1]
> > AR5416+AR5133 [1]
> > AR9160 [2]
> > AR9280 [3]
> >
> > Support dual band
> >
> > [1] http://www.atheros.com/news/xspan.html
> > [2] http://www.atheros.com/pt/AR9001AP-3NX2.htm
> > [3] http://www.atheros.com/news/AR9280_AR9281.htm3
> 
> Also,
> 
> First some alphabet soup for you (this is on the wiki now):
> 
> HB: PCIe Half MiniCard
> XB: PCIe Full MiniCard
> MB: Mini PCI card
> CB: PCI Cardbus card
> SB: Single band, 1x1, 1x2, 2x2 configuration
> DB: Dual band, 2x2 configuration

Hm and our Owl stuff also supports 3x3 IIRC so we will update that..
just not sure exactly which ones have it yet. I'll ask.

  Luis
