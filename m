Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35095 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab0JHSA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:00:56 -0400
Received: by wwj40 with SMTP id 40so1527278wwj.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 11:00:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101008174128.GC946034@jupiter.n2.diac24.net>
References: <SNT111-W2989DC6A52022428756E6FB500@phx.gbl> <20101008111221.5425.qmail@stuge.se>
 <AANLkTimAfH8ChkjwFB7e2kMbJyxaZQZMSxTcThva=jgN@mail.gmail.com>
 <SNT111-W21A1F92DC5DADE5968C8CCFB500@phx.gbl> <AANLkTikc9+bULkH2Fv7mEtBjbjatMW8XOXjXZVuA81hD@mail.gmail.com>
 <4CAF4B70.9050001@candelatech.com> <20101008165232.GI10149@tux>
 <4CAF4FDA.8060908@candelatech.com> <1286557944.3612.5.camel@jlt3.sipsolutions.net>
 <4CAF53E2.8030306@candelatech.com> <20101008174128.GC946034@jupiter.n2.diac24.net>
From: David Willmore <davidwillmore@gmail.com>
Date: Fri, 8 Oct 2010 14:00:35 -0400
Message-ID: <AANLkTi=oR_RfbNv4D-d_rXP4p4ykZC00bJRPnwjrhgo-@mail.gmail.com>
Subject: Re: [ath9k-devel] trying to set tx power (using txpower option)
To: David Lamparter <equinox@diac24.net>
Cc: Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath9k <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 8, 2010 at 1:41 PM, David Lamparter <equinox@diac24.net> wrote:
> d-B-m is deci-Bel-milliWatt, so a mBm ostensibly is a
> milli-Bel-milliWatt...
>
> (yes, the "m" really encodes "mW"...)

The value is a "Power", so the base unit of Watts is implicit.

This particular unit has always confused the heck out of me.
It's *not* milli-Bel-milliWatt or the division would be by 1000,
so it's really centi-Bel-milliWatt, no?

Cheers,
David
