Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:1777 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYIJJiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 05:38:23 -0400
Date: Wed, 10 Sep 2008 12:36:38 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] ath5k: bad udelay call, build failure on ARM
Message-ID: <20080910093638.GA16874@deprecation.cyrius.com> (sfid-20080910_113828_142754_3BE626B9)
References: <20080825115715.GA13506@deprecation.cyrius.com> <20080825190811.GC17297@tuxdriver.com> <40f31dec0808251236qad2118dv2b781b147d366415@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0808251236qad2118dv2b781b147d366415@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Nick Kossifidis <mickflemm@gmail.com> [2008-08-25 22:36]:
> > There are "udelay(2300)" calls in phy.c and hw.c.  How important is
> > that exact number?  Could those be replaced by mdelay(3) instead?
> >
> > Of course, looking in include/linux/delay.h, mdelay(3) may still
> > translate to __bad_udelay on arm.  It would be nice if the ARM guys
> > and delay.h could at least agree on the maximum value allowed to be
> > passed to udelay...
> >
> > John
> 
> Sorry for that i just haven't tested 5210 code much (these are older
> chips that need more delay). I'll do some tests asap and tweak this
> value to be in range.

Did you have a chance to do these tests yet?
-- 
Martin Michlmayr
http://www.cyrius.com/
