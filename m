Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:63865 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab0IOQec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 12:34:32 -0400
Date: Wed, 15 Sep 2010 09:34:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Vitaly Wool <vitalywool@gmail.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Nicolas Pitre <nico@fluxnic.net>,
	"Wool, Vitaly" <Vitaly.Wool@sonyericsson.com>,
	linux-wireless@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Ido Yariv <ido@wizery.com>, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	linux-mmc@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	linux-omap@vger.kernel.org, akpm@linux-foundation.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/7] native wl1271 support on ZOOM
Message-ID: <20100915163403.GT8647@atomide.com>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
 <AANLkTikedoL3HjohQfq2qa0TU5yMJR5p1GqyQJtQGrdb@mail.gmail.com>
 <AANLkTingdk=9Fbp9uKf6rGyAtR+b8KV4vFmYRfakkwBs@mail.gmail.com>
 <20100915132149.GA6997@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100915132149.GA6997@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* John W. Linville <linville@tuxdriver.com> [100915 06:21]:
> On Wed, Sep 15, 2010 at 01:08:18PM +0200, Vitaly Wool wrote:
> > On Wed, Sep 15, 2010 at 11:21 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > > On Wed, Sep 1, 2010 at 11:26 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > >> This patchset adds wl1271 support on ZOOM2/3 boards.
> > >
> > > Tony, John, let me please suggest merging this through the wireless tree.
> > >
> > > wl1271 is a moving target - it keeps changing in the wireless tree and
> > > merging this patchset there will allow wl1271 developers to have
> > > everything in a single tree (and prevent merge conflicts in
> > > linux-next).
> > 
> > Thanks Ohad, that's what I was about to suggest as well. :)
> 
> OK, that is fine with me if the omap folks agree?

Yes sounds good to me, I think there's still at least some platform_data
conversation going on though.

Tony
