Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49515 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbaKTUjB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 15:39:01 -0500
Message-ID: <1416515933.8557.13.camel@sipsolutions.net> (sfid-20141120_213905_048168_4153038E)
Subject: Re: [PATCH v2 1/4] cfg80211: leave invalid channels on regdomain
 change
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Arik Nemtsov <arik@wizery.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 20 Nov 2014 21:38:53 +0100
In-Reply-To: <20141120203525.GP24486@wotan.suse.de> (sfid-20141120_213544_633693_4A91930E)
References: <1415895219-19848-1-git-send-email-arik@wizery.com>
	 <20141113224556.GD24486@wotan.suse.de>
	 <CA+XVXffuKE2heFPWmVWGre8cL3VZX5U63_Rru9uXKiqbpz5xYA@mail.gmail.com>
	 <20141120203525.GP24486@wotan.suse.de>
	 (sfid-20141120_213544_633693_4A91930E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-20 at 21:35 +0100, Luis R. Rodriguez wrote:

> It really should only kick you off of channels you are not allowed to use,
> I welcome this change and think it is important as a standard feature.
> Please rename to REGULATORY_IGNORE_STALE_KICKOFF and make the behaviour
> change to ignore the kick off rather than opt-in. We take measures to
> operate properly regulatory and this change helps in that direction, we
> want opt-in features to let folks that know what they are doing ingore
> certain fatures.

> > I don't want to add modes I cannot test with HW I have. I think that's
> > irresponsible, especially when the side-effects are disconnections.
> > I can add IBSS as well with the HW I have, but that's about it.
> 
> I'd like to see IBSS and Mesh considered and addressed.

And I want a cookie :-)

I outlined what I'll accept in my other email, and since I think it's
unreasonable to force Arik to revamp the whole thing the behaviour will
have to stay opt-in, at least until all modes are addressed, at which
point the flag could even go away.

johannes

