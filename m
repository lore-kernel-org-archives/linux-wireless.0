Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36012 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2EICcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 22:32:50 -0400
Date: Tue, 8 May 2012 21:48:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Remove compile warnings
Message-ID: <20120509014852.GA2533@tuxdriver.com> (sfid-20120509_043254_201750_594092E5)
References: <1335357955-28089-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1336071617.5167.9.camel@jlt3.sipsolutions.net>
 <CAMXE1-qniMzGi97U2oDPxyvSsms7nZpy6QfZVZPpnrC0WcNMqQ@mail.gmail.com>
 <1336383024.4325.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336383024.4325.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 07, 2012 at 11:30:24AM +0200, Johannes Berg wrote:
> On Fri, 2012-05-04 at 11:44 +0300, Andrei Emeltchenko wrote:
> 
> > >> -             case NL80211_IFTYPE_UNSPECIFIED:
> > >> -             case NUM_NL80211_IFTYPES:
> > >> +             default:
> > >
> > > When did this warning start occurring? I was pretty sure it didn't use
> > > to? I think we should explicitly list the cases here though because we
> > > want the compiler to warn here when we add something to the interface
> > > type list so we catch this place that may have to be modified.
> > 
> > I think warning occurs when I added new interface type since it is
> > also not handled.
> 
> Well, but in that case the warning is supposed to happen to tell you
> that you need to think about that code for your new interface type.
> 
> John, please revert this patch.

I'm having to do some rebasing to handle the bluetooth kerfuffle.
I'll simply drop this patch.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
