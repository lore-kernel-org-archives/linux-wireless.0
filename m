Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4629 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbXLDQPp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:15:45 -0500
Date: Tue, 4 Dec 2007 11:14:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] less eventcause shifts
Message-ID: <20071204161445.GJ19911@tuxdriver.com> (sfid-20071204_161600_008600_E333DFDD)
References: <200711280915.11300.hs4233@mail.mn-solutions.de> <1196704681.21151.13.camel@localhost.localdomain> <1196714939.13978.171.camel@pmac.infradead.org> <20071204145437.GC19911@tuxdriver.com> <1196780866.13978.275.camel@pmac.infradead.org> <20071204152122.GE19911@tuxdriver.com> <1196782170.13978.296.camel@pmac.infradead.org> <1196784002.26155.62.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196784002.26155.62.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 04, 2007 at 11:00:02AM -0500, Dan Williams wrote:

> However it works out, as long as the work in libertas-2.6 doesn't drag
> out too long.  Slow and steady does not win the race here :)  Not sure
> what's involved if Jeff has already pulled from John; but if not, John
> could drop the current libertas set and you (david) can _ensure_ that
> they get into libertas-2.6 so nothing gets dropped on the floor.

If the new patches come fast enough to guarantee that then I have to
believe that we can work-out how to merge the new patches on top of
what I've already sent.  So, I would prefer to let the pull request
I sent today stand.

John
-- 
John W. Linville
linville@tuxdriver.com
