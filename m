Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbXLDQXg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:23:36 -0500
Subject: Re: [PATCH] less eventcause shifts
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org
In-Reply-To: <20071204161445.GJ19911@tuxdriver.com>
References: <200711280915.11300.hs4233@mail.mn-solutions.de>
	 <1196704681.21151.13.camel@localhost.localdomain>
	 <1196714939.13978.171.camel@pmac.infradead.org>
	 <20071204145437.GC19911@tuxdriver.com>
	 <1196780866.13978.275.camel@pmac.infradead.org>
	 <20071204152122.GE19911@tuxdriver.com>
	 <1196782170.13978.296.camel@pmac.infradead.org>
	 <1196784002.26155.62.camel@localhost.localdomain>
	 <20071204161445.GJ19911@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 11:17:20 -0500
Message-Id: <1196785040.26155.70.camel@localhost.localdomain> (sfid-20071204_162353_955746_D36B48CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-12-04 at 11:14 -0500, John W. Linville wrote:
> On Tue, Dec 04, 2007 at 11:00:02AM -0500, Dan Williams wrote:
> 
> > However it works out, as long as the work in libertas-2.6 doesn't drag
> > out too long.  Slow and steady does not win the race here :)  Not sure
> > what's involved if Jeff has already pulled from John; but if not, John
> > could drop the current libertas set and you (david) can _ensure_ that
> > they get into libertas-2.6 so nothing gets dropped on the floor.
> 
> If the new patches come fast enough to guarantee that then I have to
> believe that we can work-out how to merge the new patches on top of
> what I've already sent.  So, I would prefer to let the pull request
> I sent today stand.

That would be my preference too; since it's already all said and done...

Dan

