Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997Ab0JHSFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:05:49 -0400
Subject: Re: [ath9k-devel] trying to set tx power (using txpower option)
From: Johannes Berg <johannes@sipsolutions.net>
To: David Willmore <davidwillmore@gmail.com>
Cc: David Lamparter <equinox@diac24.net>,
	Ben Greear <greearb@candelatech.com>,
	ath9k <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=oR_RfbNv4D-d_rXP4p4ykZC00bJRPnwjrhgo-@mail.gmail.com>
References: <SNT111-W2989DC6A52022428756E6FB500@phx.gbl>
	 <20101008111221.5425.qmail@stuge.se>
	 <AANLkTimAfH8ChkjwFB7e2kMbJyxaZQZMSxTcThva=jgN@mail.gmail.com>
	 <SNT111-W21A1F92DC5DADE5968C8CCFB500@phx.gbl>
	 <AANLkTikc9+bULkH2Fv7mEtBjbjatMW8XOXjXZVuA81hD@mail.gmail.com>
	 <4CAF4B70.9050001@candelatech.com> <20101008165232.GI10149@tux>
	 <4CAF4FDA.8060908@candelatech.com>
	 <1286557944.3612.5.camel@jlt3.sipsolutions.net>
	 <4CAF53E2.8030306@candelatech.com>
	 <20101008174128.GC946034@jupiter.n2.diac24.net>
	 <AANLkTi=oR_RfbNv4D-d_rXP4p4ykZC00bJRPnwjrhgo-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 20:05:46 +0200
Message-ID: <1286561146.3612.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-08 at 14:00 -0400, David Willmore wrote:
> On Fri, Oct 8, 2010 at 1:41 PM, David Lamparter <equinox@diac24.net> wrote:
> > d-B-m is deci-Bel-milliWatt, so a mBm ostensibly is a
> > milli-Bel-milliWatt...
> >
> > (yes, the "m" really encodes "mW"...)
> 
> The value is a "Power", so the base unit of Watts is implicit.
> 
> This particular unit has always confused the heck out of me.
> It's *not* milli-Bel-milliWatt or the division would be by 1000,
> so it's really centi-Bel-milliWatt, no?

No, the d in dB already means it's 1/10 B, and mB is (was meant to be)
1/1000 B -- so the conversion factor is 100.

johannes

