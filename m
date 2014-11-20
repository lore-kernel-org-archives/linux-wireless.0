Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899AbaKTU4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 15:56:40 -0500
Date: Thu, 20 Nov 2014 21:56:38 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] cfg80211: leave invalid channels on regdomain
	change
Message-ID: <20141120205638.GS24486@wotan.suse.de> (sfid-20141120_215642_551277_92DCEA5F)
References: <1415895219-19848-1-git-send-email-arik@wizery.com> <20141113224556.GD24486@wotan.suse.de> <CA+XVXffuKE2heFPWmVWGre8cL3VZX5U63_Rru9uXKiqbpz5xYA@mail.gmail.com> <20141120203525.GP24486@wotan.suse.de> <1416515933.8557.13.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416515933.8557.13.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2014 at 09:38:53PM +0100, Johannes Berg wrote:
> On Thu, 2014-11-20 at 21:35 +0100, Luis R. Rodriguez wrote:
> 
> > It really should only kick you off of channels you are not allowed to use,
> > I welcome this change and think it is important as a standard feature.
> > Please rename to REGULATORY_IGNORE_STALE_KICKOFF and make the behaviour
> > change to ignore the kick off rather than opt-in. We take measures to
> > operate properly regulatory and this change helps in that direction, we
> > want opt-in features to let folks that know what they are doing ingore
> > certain fatures.
> 
> > > I don't want to add modes I cannot test with HW I have. I think that's
> > > irresponsible, especially when the side-effects are disconnections.
> > > I can add IBSS as well with the HW I have, but that's about it.
> > 
> > I'd like to see IBSS and Mesh considered and addressed.
> 
> And I want a cookie :-)
> 
> I outlined what I'll accept in my other email, and since I think it's
> unreasonable to force Arik to revamp the whole thing the behaviour will
> have to stay opt-in, at least until all modes are addressed, at which
> point the flag could even go away.

Fine..

  Luis
