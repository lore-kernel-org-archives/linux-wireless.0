Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43723 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbZKFSpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 13:45:08 -0500
Date: Fri, 6 Nov 2009 13:38:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Vivek Natarajan <vivek.natraj@gmail.com>,
	Jeffrey Baker <jwbaker@gmail.com>,
	David Quan <David.Quan@atheros.com>,
	Michael Green <Michael.Green@atheros.com>
Subject: Re: Changing the way we handle region codes on Linux (public
	thread)
Message-ID: <20091106183833.GC2782@tuxdriver.com>
References: <43e72e890911060857l6e383578nc1c7d0f2ba63529f@mail.gmail.com> <b6c5339f0911060929w78d16192o6c48e432e8e8c830@mail.gmail.com> <43e72e890911060945s3b00e056u1efe483bd88ebd30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890911060945s3b00e056u1efe483bd88ebd30@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 06, 2009 at 09:45:29AM -0800, Luis R. Rodriguez wrote:
> On Fri, Nov 6, 2009 at 9:29 AM, Bob Copeland <me@bobcopeland.com> wrote:
> > On Fri, Nov 6, 2009 at 11:57 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> >
> >> I think that sums it up.
> >
> > I personally still like the idea of pushing the vendor-specific
> > codes out to user space and having psuedo-country codes for
> > those (e.g. "ATH_37").  Then the driver doesn't need all of the
> > static rules loaded all the time and it would drop a lot of
> > policy code from the driver.  CRDA could be enhanced to load
> > multiple databases, one for pure iso-3166 codes, one with
> > Atheros codes, one with Intel, etc.

<snip>

> But with that said -- I think the region-code scheme is overly complex
> and am not sure if aiding it is something we should focus energy and
> resources on. It would seem better to me to focus on more cleaner
> solutions and leave that old stuff as legacy solutions.

That's the thing about "legacy" stuff -- it doesn't go away just from
ignoring it!

FWIW, I think Bob's suggestion makes a lot of sense.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
