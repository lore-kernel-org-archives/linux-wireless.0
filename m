Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:51473 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171Ab1CKScI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 13:32:08 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>, Greg KH <greg@kroah.com>,
	"David S. Miller" <davem@davemloft.net>
Date: Fri, 11 Mar 2011 10:31:26 -0800
Subject: RE: [PATCH 00/31] wireless: Marvell mwifiex driver for SD8787
Message-ID: <477F20668A386D41ADCC57781B1F704307F5244DCE@SC-VEXCH1.marvell.com>
References: <1291253516-17815-1-git-send-email-bzhao@marvell.com>
 <1291380780.3499.119.camel@jlt3.sipsolutions.net>
 <477F20668A386D41ADCC57781B1F704307F51C401C@SC-VEXCH1.marvell.com>
 <1299833115.3755.1.camel@jlt3.sipsolutions.net>
 <20110311141230.GA14583@tuxdriver.com>
In-Reply-To: <20110311141230.GA14583@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> -----Original Message-----
> From: John W. Linville [mailto:linville@tuxdriver.com]
> Sent: Friday, March 11, 2011 6:13 AM
> To: Johannes Berg
> Cc: Bing Zhao; linux-wireless@vger.kernel.org; Dan Williams; David Woodhouse; Amitkumar Karwar; Kiran
> Divekar; Greg KH; David S. Miller
> Subject: Re: [PATCH 00/31] wireless: Marvell mwifiex driver for SD8787
> 
> On Fri, Mar 11, 2011 at 09:45:15AM +0100, Johannes Berg wrote:
> > Hi,
> >
> > > During the past 3 months, we have made 56 mwifiex patches (listed
> > > below) since the initial mwifiex driver submission. Most of these
> > > patches address the above issues; and the ioctl multiple abstraction
> > > layers and the static forward declarations as you commented in another
> > > e-mail. Some other patches are for code cleanups, mainly coding style.
> >
> > I've only loosely followed these patches, but I'm sure the driver is in
> > *much* better shape now. If you think you're done, it'd be worthwhile to
> > just resubmit the entire driver in its new version.
> >
> > johannes
> 
> Agreed -- please resubmit the driver as either a single patch
> for inclusion or possibly as a small series of patches grouped by
> functionality for further review.

Thanks to John and Johannes. I will prepare the patch and resend.

Bing

> 
> Thanks!
> 
> John
> --
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
