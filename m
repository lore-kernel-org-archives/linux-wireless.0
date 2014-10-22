Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50845 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbaJVOHi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 10:07:38 -0400
Message-ID: <1413986851.28927.4.camel@jlt4.sipsolutions.net> (sfid-20141022_160742_540319_B05C29E3)
Subject: Re: [PATCH v5 0/4] add VHT support to minstrel_ht
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Date: Wed, 22 Oct 2014 16:07:31 +0200
In-Reply-To: <20141022135438.GA29537@magnum.frso.rivierawaves.com> (sfid-20141022_155505_233511_F6AE4FD7)
References: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com>
	 <1413816546.32358.3.camel@jlt4.sipsolutions.net>
	 <20141020151302.GB7691@magnum.frso.rivierawaves.com>
	 <20141020153421.GC7691@magnum.frso.rivierawaves.com>
	 <1413833597.32358.6.camel@jlt4.sipsolutions.net>
	 <20141021152658.GA14839@magnum.frso.rivierawaves.com>
	 <1413917246.1998.7.camel@jlt4.sipsolutions.net>
	 <20141022135438.GA29537@magnum.frso.rivierawaves.com>
	 (sfid-20141022_155505_233511_F6AE4FD7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-22 at 15:54 +0200, Karl Beldan wrote:
> On Tue, Oct 21, 2014 at 08:47:26PM +0200, Johannes Berg wrote:
> > On Tue, 2014-10-21 at 17:26 +0200, Karl Beldan wrote:
> > 
> > > I still don't know why I don't see the smatch array warnings here, I
> > > guess I'll live with that for now.
> > 
> > I'm hoping Dan will eventually pick up on it ;-)
> > 
> smatch is good, I get your warnings now when unsetting
> MAC80211_RC_MINSTREL_VHT. I did not click until after checking
> checking smatch's check_overflow.c, when there's a use after check, it
> only barks when the indexes checked are out of bounds.

Wait, are you saying it *is* out of bounds when VHT isn't turned on?

johannes

