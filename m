Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:56922 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757234Ab0JHQwf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 12:52:35 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 09:52:26 -0700
Date: Fri, 8 Oct 2010 09:52:32 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath9k <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] trying to set tx power (using txpower option)
Message-ID: <20101008165232.GI10149@tux>
References: <SNT111-W333C4BA6050D535151071FFB690@phx.gbl>
 <SNT111-W2989DC6A52022428756E6FB500@phx.gbl>
 <20101008111221.5425.qmail@stuge.se>
 <AANLkTimAfH8ChkjwFB7e2kMbJyxaZQZMSxTcThva=jgN@mail.gmail.com>
 <SNT111-W21A1F92DC5DADE5968C8CCFB500@phx.gbl>
 <AANLkTikc9+bULkH2Fv7mEtBjbjatMW8XOXjXZVuA81hD@mail.gmail.com>
 <4CAF4B70.9050001@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CAF4B70.9050001@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 08, 2010 at 09:48:48AM -0700, Ben Greear wrote:
> On 10/08/2010 09:45 AM, Luis R. Rodriguez wrote:
> > On Fri, Oct 8, 2010 at 9:23 AM, At Santos<atsan@hotmail.co.uk>  wrote:
> >>
> >>
> >>> Actually, you can set tx power with iw now:
> >>>
> >>> http://wireless.kernel.org/en/users/Documentation/iw#Setting_TX_power
> >>>
> >>> I will note you will need 2.6.36, or compat-wireless-2.6.36, otherwise
> >>> you have to use iwconfig, setting txpower with nl80211 was only added
> >>> as of 2.6.36.
> >>>
> >>> Luis
> >>
> >> Thanks for the response.
> >>
> >> I'm running with compat-wireless-2.6.36-rc3-1 and I'm finding that iw
> >> doesn't work with fixed or limit:
> >>
> >> $ sudo iw wlan0 set txpower fixed 20
> >> command failed: Operation not supported (-95)
> >>
> >> So it seems it's broken at the moment.
> >> To where should I report the bug?
> >
> > You can use bugzilla.kernel.org please report it there and we can fix
> > it. I can't look into right now though as I'm looking into another
> > issue. If someone else has cycles it would be appreciated.
> 
> I might be able to work on this,

awesome, thanks!

> in wireless-testing tree at least.

All development is assumed to take places on wireless-testing.git anyway, and
to send a fix for older kernels we first must address it there so indeed
its always the right place to do development, even for stable.

  Luis
