Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:49946 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751697AbZDNCNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 22:13:49 -0400
Date: Mon, 13 Apr 2009 19:10:57 -0700
From: Greg KH <greg@kroah.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: VT6656 driver source now GPL
Message-ID: <20090414021057.GB17559@kroah.com> (sfid-20090414_041356_689159_D5695BED)
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com> <20090320131014.GG25237@storm.local.network> <20090414000835.GA31504@storm.local.network> <49E3D7AA.1050207@lwfinger.net> <20090414005523.GC31504@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090414005523.GC31504@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2009 at 08:55:23PM -0400, Forest Bond wrote:
> Hi,
> 
> [Re-added Cc's, hope you hadn't dropped them on purpose.  Sorry for spamming if
> they were trimmed deliberately.]
> 
> On Mon, Apr 13, 2009 at 07:24:10PM -0500, Larry Finger wrote:
> > Forest Bond wrote:
> > 
> > > I'm getting the sense that there is not a lot of developer interest in these
> > > drivers.  Is there anything I can do to aid in getting these drivers into the
> > > kernel?
> > > 
> > > I would be willing to send patches, however, my experience with kernel hacking
> > > is limited and I don't have a lot of time available to contribute.  With a
> > > little direction, though, I might be able to get somewhere.
> > > 
> > > Any input would be appreciated.
> > 
> > You might be able to get it added to the drivers/staging directory - that is
> > where the c r a p drivers that have no chance of making it to mainline are put.
> > 
> > To see what is wrong with that driver, compare its coding style to that of any
> > driver in the drivers/net/wireless directory tree.
> > 
> > A second problem is that no new drivers that implement a software-based MAC
> > layer are likely to be accepted - this driver would have to be modified to use
> > mac80211.
> 
> Great, this is enough to get started, at least.  I assume that the quality bar
> is low for code in drivers/staging.  Low quality work is a trademark of mine, so
> I should be able to tackle this. ;)
> 
> Is there any reason I ought to think that it would be easier to get this
> accepted in linux-staging than drivers/staging?  I'll admit that I feel better
> about the layout of drivers/staging than I do about the quilt stuff in
> linux-staging.

linux-staging is dead and gone and entirely contained within
drivers/staging/ now, so there is no such choice :)

thanks,

greg k-h
