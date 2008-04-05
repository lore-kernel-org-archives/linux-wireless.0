Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:44279 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYDEB1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 21:27:12 -0400
From: Chr <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/5] p54: update Makefile and Kconfig
Date: Sat, 5 Apr 2008 03:27:09 +0200
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net
References: <E1Jhv2j-0006LQ-3j@debian64.daheim> <200804050242.36018.chunkeey@web.de> <1207357659.3860.0.camel@johannes.berg>
In-Reply-To: <1207357659.3860.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804050327.09822.chunkeey@web.de> (sfid-20080405_022719_332467_32C0A51A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 April 2008 03:07:38 Johannes Berg wrote:
> On Sat, 2008-04-05 at 02:42 +0200, Chr wrote:
> > On Saturday 05 April 2008 02:26:07 Johannes Berg wrote:
> > > > John? can you please do the git mv?
> > > > I have attached a diff to make checkpatch.pl happy, so you don't have
> > > > to do it. ;-)
> > >
> > > Uh, I think you need at least a small patch that modifies the
> > > drivers/net/wireless/{Makefile,Kconfig} as appropriate. From what I
> > > could see, your original patch didn't even add the wireless/p54/Kconfig
> > > into wireless/Kconfig so it wouldn't be useful?
> >
> > hmmmmm, look careful! one small + ;-) it's nearly invisible.
> >
> > +source "drivers/net/wireless/p54/Kconfig"
>
> Ah, so we need this patch (5/5) and the git mv. Sorry, got confused
> because you sent some other patch :)
yes, this and p54-net2280-replace-space-with-tabs.patch as checkpatch.pl
looks really awful without it...

Regards,
	Chr.
