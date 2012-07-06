Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50500 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2GFUd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:33:28 -0400
Date: Fri, 6 Jul 2012 16:18:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Steev Klimaszewski <steev@genesi-usa.com>
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
Message-ID: <20120706201839.GE1879@tuxdriver.com> (sfid-20120706_223331_707391_86BE1902)
References: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
 <CAMG6FYjYMqf9C15Bid3hAfzTcB=gEXq8RWRcM9n+HNtvckgVZQ@mail.gmail.com>
 <CAFED-jk84vKMRr_NDThMqhZrnXt6ddhViztitB_=M_nKbC6c8Q@mail.gmail.com>
 <CA+Bgp3N2gUDoey-cXV+4sN0q+2Jm7+rPcu776FMUWxaR4F0qwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+Bgp3N2gUDoey-cXV+4sN0q+2Jm7+rPcu776FMUWxaR4F0qwg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 05, 2012 at 01:16:31PM -0500, Steev Klimaszewski wrote:
> On Thu, May 31, 2012 at 12:45 AM, Janusz Dziedzic
> <janusz.dziedzic@gmail.com> wrote:
> > 2012/5/9 Dmitry Tarnyagin <abi.dmitryt@gmail.com>:
> >> Hi,
> >>
> >> Could you please check status of this submission? It looks like review
> >> was passed, but patchset was not taken in. Have I done something
> >> wrong?
> >>
> >
> > Any news?
> >
> >
> > BR
> > Janusz
> > --
> 
> Any news on this?

Sorry, I kinda lost track of this.  I guess I was expecting a repost,
including Bob Copeland's patches and something to address the endian
issues mentioned by Kevin Groenevel.  Was anyone planning to address
those concerns?  Also, I'm not sure that bit about needing custom
SDD files was fully addressed?

On top of that, there were some style quirks that I was hoping
someone could address.  There were "if 0" blocks in the code, which
is rather questionable.  Was anyone planning to remove them?  Also,
the block comment formats seemed a little random.  In particular, the
single-line "/* ********* */" thing looks a bit funny.  Perhaps that
isn't the worst thing ever but if you are going to respin anyway than
I'd prefer if you just deleted them.

There was also talk of a mac80211 patch needed to fix a bug observed
with the driver as posted?  Has that mac80211 fix been posted and
merged?  If not, when will we see it?

So anyway, it seems like a repost of the current version (i.e. with
Bob's fixes, etc) is in order?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
