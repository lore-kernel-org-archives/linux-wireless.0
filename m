Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48060 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0ION3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 09:29:44 -0400
Date: Wed, 15 Sep 2010 09:21:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
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
Message-ID: <20100915132149.GA6997@tuxdriver.com>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
 <AANLkTikedoL3HjohQfq2qa0TU5yMJR5p1GqyQJtQGrdb@mail.gmail.com>
 <AANLkTingdk=9Fbp9uKf6rGyAtR+b8KV4vFmYRfakkwBs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTingdk=9Fbp9uKf6rGyAtR+b8KV4vFmYRfakkwBs@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 01:08:18PM +0200, Vitaly Wool wrote:
> On Wed, Sep 15, 2010 at 11:21 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > On Wed, Sep 1, 2010 at 11:26 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> >> This patchset adds wl1271 support on ZOOM2/3 boards.
> >
> > Tony, John, let me please suggest merging this through the wireless tree.
> >
> > wl1271 is a moving target - it keeps changing in the wireless tree and
> > merging this patchset there will allow wl1271 developers to have
> > everything in a single tree (and prevent merge conflicts in
> > linux-next).
> 
> Thanks Ohad, that's what I was about to suggest as well. :)

OK, that is fine with me if the omap folks agree?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
