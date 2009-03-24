Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64467 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZCXV7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 17:59:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 14:59:23 -0700
Date: Tue, 24 Mar 2009 13:58:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Christian Lamparter <chunkeey@web.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
Message-ID: <20090324205847.GB29268@tesla> (sfid-20090324_225928_317956_271072A7)
References: <200903241938.47155.chunkeey@web.de> <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com> <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com> <200903242133.28405.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200903242133.28405.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 01:33:27PM -0700, Christian Lamparter wrote:
> On Tuesday 24 March 2009 21:10:21 Luis R. Rodriguez wrote:
> > On Tue, Mar 24, 2009 at 1:03 PM, Bob Copeland <me@bobcopeland.com> wrote:
> > > On Tue, Mar 24, 2009 at 2:41 PM, Luis R. Rodriguez
> > > <lrodriguez@atheros.com> wrote:
> > >> Do any of you guys have time to pick it up?
> > >
> > > Well my patch #2 is pretty similar to what Christian has, and I'd like to
> > > upstream the first few patches soon (especially the ath.ko creation, it is a
> > > beast to rebase as you saw).  That would bring up the first contentious
> > > point of the merge: is "ath/ath.ko" ok with everyone?
> >
> > Yes.
> Yes.
> 
> > > ath5k/9k specific
> > > bits can eventually go in ath/{5k,9k} subdirs... not sure where 9170
> > > lives then :)
> >
> > Wherever Christian wants it. If he finds re-usable bits then great.
> maybe ath/9kusb ?

In that case maybe 9170/, we do have future USB plans.

> > > I probably can't get to it until the weekend, but if you have more time,
> > > Christian, feel free to adopt whatever you want from mine.  Otherwise I'll
> > > pick up where Luis left off on the weekend.
> Done! Patch attached, please add to the tree ;)

Nice....... so it seems all we need now is ath5k figured out and properly
tested.

  Luis
