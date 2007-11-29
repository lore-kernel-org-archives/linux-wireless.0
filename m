Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3525 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759479AbXK2BGL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 20:06:11 -0500
Date: Wed, 28 Nov 2007 19:58:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: coding style lesson: iwlwifi vs. endianness
Message-ID: <20071129005810.GA6161@tuxdriver.com> (sfid-20071129_010614_723394_59CBE1ED)
References: <1196189059.6058.95.camel@johannes.berg> <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com> <1196286192.4967.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196286192.4967.29.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 28, 2007 at 04:43:12PM -0500, Dan Williams wrote:
> On Wed, 2007-11-28 at 20:20 +0200, Tomas Winkler wrote:
> > If you would compose your email in less arrogant tone I would answer
> > you why your assumptions are wrong.
> > I know it is tempting to teach BIG Intel, but please try to keep good
> > spirit on this mailing list as it was so far.
> > Thanks
> > Tomas.
> 
> Ignoring the email tones and focusing on the problem, could you
> elaborate your reasons?  Doing endian conversions at the boundaries is
> quite a bit simpler and does lead to cleaner, more readable code.  The
> bulk of the work being done with a softmac card is in the driver +
> stack, so the clearer those are, the better for everyone.

ACK

While I can understand why you might think that Johannes was being
smug, I doubt if he really meant to be.  Please try to presume the
best intent. :-)

As Dan points-out, Johannes main point (i.e. convert data at system
boundaries) makes plenty of sense.  Please do take the time to tell
us what he is missing?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
