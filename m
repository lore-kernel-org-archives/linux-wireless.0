Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40957 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbZHNDtK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 23:49:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 20:49:12 -0700
Date: Thu, 13 Aug 2009 20:49:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 00/25] wireless: cleanup and reorganize kconfig
Message-ID: <20090814034911.GB28524@mosca>
References: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
 <4A84DB04.6070105@lwfinger.net>
 <20090814034105.GA28524@mosca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090814034105.GA28524@mosca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 08:41:05PM -0700, Luis Rodriguez wrote:
> On Thu, Aug 13, 2009 at 08:33:24PM -0700, Larry Finger wrote:
> > Luis R. Rodriguez wrote:
> > > John, here's a second iteration of this series, this time
> > > I'm using a menu (config) which expands upon selection for
> > > groups which have only a few drivers. For groups which do tend
> > > to pollute your screen I've put them under their own menu
> > > (menuconfig). At first I had each group with an appended
> > > "wireless drivers support" but in the end that seemed too
> > > odd so I removed it and now group drivers are pivoted by
> > > the vendor driver.
> > >
> > > I've kept rndis_wlan on its own although only currently
> > > known chipsets which support it are Broadcom based.
> > > I also don't expect old rndis_wlan users to know
> > > that this is a broadcom driver for now so its better
> > > to keep that apart.
> > >
> > > Let me know if you like the color of the shed, its
> > > understandable if you dislike it.
> >
> > #4 is missing this time. That is probably the reason that #13 has some
> > fuzz, and #15 fails. In addition, once you apply past #3, youo get an
> > error
> > drivers/net/wireless/Kconfig:498: file
> > 'drivers/net/wireless/p54/Kconfig' is already sourced from
> > 'drivers/net/wireless/Kconfig'
> > make[1]: *** [xconfig] Error 1
> > make: *** [xconfig] Error 2
> 
> Oh ok, thanks I'll resend, also noticed a typo on #15. Will resend that one as well.

The typo was on #16.

  Luis
