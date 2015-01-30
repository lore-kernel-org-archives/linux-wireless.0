Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52840 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbbA3IRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 03:17:43 -0500
Message-ID: <1422605861.1919.3.camel@sipsolutions.net> (sfid-20150130_091745_611813_1A94EFF5)
Subject: Re: moving the wiki
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 30 Jan 2015 09:17:41 +0100
In-Reply-To: <1422605517.1919.2.camel@sipsolutions.net> (sfid-20150130_091202_226222_1D871A9F)
References: <1392060043.4128.37.camel@jlt4.sipsolutions.net>
	 <1422543484.6322.10.camel@sipsolutions.net>
	 <CACna6rzvhJGgQNWBZvfTSz4bsFRsTPcZNiKoZ+po==u6K8gEEg@mail.gmail.com>
	 (sfid-20150130_071550_392649_560599F3) <1422605517.1919.2.camel@sipsolutions.net>
	 (sfid-20150130_091202_226222_1D871A9F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 09:11 +0100, Johannes Berg wrote:
> On Fri, 2015-01-30 at 07:15 +0100, Rafał Miłecki wrote:
> > On 29 January 2015 at 15:58, Johannes Berg <johannes@sipsolutions.net> wrote:
> > >> Obviously, another consequence is that the wiki markup will change
> > >> somewhat. Moin and Mediawiki aren't too far from each other (except for
> > >> table syntax), but there are some things that are different that you'll
> > >> have to get used to when editing.
> > >
> > > Again, dokuwiki - slightly different from moinmoin.
> > 
> > Tables using colspans were not moved correctly, see e.g.:
> > https://wireless.wiki.kernel.org/en/users/Drivers/b43/soc
> > 
> > It displays "–colspan=3–Chip" in a table cell.
> 
> I thought I fixed colspan/rowspan in my conversion, but I guess I didn't
> get that right...

Ah, two things - I left some debug thing (the --colspan=x--) and I
messed up when it's combined col/rowspan.

I'll see if I can fix it.

johannes

