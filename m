Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41182 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab2CGSrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 13:47:17 -0500
Date: Wed, 7 Mar 2012 13:40:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Paul Stewart <pstew@chromium.org>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Arik Nemtsov <anamtsov@gmail.com>,
	Eliad Peller <eliad@wizery.com>
Subject: Re: [RFCv2] mac80211: Don't let regulatory make us deaf
Message-ID: <20120307184027.GC12245@tuxdriver.com> (sfid-20120307_194721_183164_44981693)
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
 <20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com>
 <1330254954.4401.9.camel@jlt3.sipsolutions.net>
 <1330255537.4401.10.camel@jlt3.sipsolutions.net>
 <1330338898.3483.10.camel@jlt3.sipsolutions.net>
 <20120227113212.GA4576@w1.fi>
 <1330342730.3483.34.camel@jlt3.sipsolutions.net>
 <20120227134610.GA5070@w1.fi>
 <CAMcMvshUH5faQ7xZTkXgWE=v-WMShBa9dOPZ=nu3hYiGJvoeFA@mail.gmail.com>
 <1331105774.3519.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331105774.3519.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 07, 2012 at 08:36:14AM +0100, Johannes Berg wrote:
> On Tue, 2012-03-06 at 21:46 -0800, Paul Stewart wrote:
> 
> > >> Of course, if this we actually happen to come across a device that needs
> > >> this it could set a flag somehwere and mac80211 could re-configure the
> > >> channel to non-HT on the assoc request, but right now I'd rather not
> > >> worry about that since we're moving towards multi-channel and have no
> > >> indication of such devices existing. Agree?
> > >
> > > Yeah, that works for me.
> > 
> > Discussions seem to have come to an end here, however I'm not sure
> > what we ended up deciding. :-)  I see mention of HT+TKIP -- not sure
> > I'm familiar enough with what the issues are there -- as well as
> > pushing the channel configuration earlier and perhaps changes to the
> > association process.  Since I may not have a complete handle on all
> > these adjacent issues, where do we want to go with the current change
> > (fixes a real-life issue) and how do we want to stage that with
> > respect to the other issues this seems to have brought to the surface?
> 
> This discussion really side-tracked somewhat -- we were discussing a
> better/different solution. I'm OK with your patch, but since I'll be
> touching the code again to address the other things we talked about it'd
> be great if you could test after that again, maybe in a week or two?

So, should I wait to merge Paul's patch until after the merge window
(i.e. only merge it for 3.5)?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
