Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10035 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbZCXWPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 18:15:21 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 15:15:20 -0700
Date: Tue, 24 Mar 2009 14:14:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
Message-ID: <20090324211444.GC29268@tesla> (sfid-20090324_231544_300500_C8CD84E5)
References: <200903241938.47155.chunkeey@web.de> <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com> <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com> <200903242133.28405.chunkeey@web.de> <20090324205847.GB29268@tesla> <20090324220558.M48235@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090324220558.M48235@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 03:09:12PM -0700, Bob Copeland wrote:
> On Tue, 24 Mar 2009 13:58:47 -0700, Luis R. Rodriguez wrote
> > > > > pick up where Luis left off on the weekend.
> > > Done! Patch attached, please add to the tree ;)
> >
> > Nice....... so it seems all we need now is ath5k figured out and properly
> > tested.
> 
> BTW there's a dumb bug in my first patch, missing 'break' in the switch
> statements.  Oops.  But ath5k wasn't using any of that since it didn't
> do the CTL stuff yet.
> 
> I'll go ahead and rebase the stuff and repost it later in the week,
> as long as you guys can test ath9k/ar9170 then I can do the debugging
> for 5k..

Nice, I think I can at least commit now to reviewing and testing ath9k
stuff. The good news is this is all going for a .31 so we'll have a good
amount of time to test.

  Luis
