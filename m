Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40084 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1CKOQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 09:16:01 -0500
Date: Fri, 11 Mar 2011 09:12:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>, Greg KH <greg@kroah.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/31] wireless: Marvell mwifiex driver for SD8787
Message-ID: <20110311141230.GA14583@tuxdriver.com>
References: <1291253516-17815-1-git-send-email-bzhao@marvell.com>
 <1291380780.3499.119.camel@jlt3.sipsolutions.net>
 <477F20668A386D41ADCC57781B1F704307F51C401C@SC-VEXCH1.marvell.com>
 <1299833115.3755.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1299833115.3755.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 11, 2011 at 09:45:15AM +0100, Johannes Berg wrote:
> Hi,
> 
> > During the past 3 months, we have made 56 mwifiex patches (listed
> > below) since the initial mwifiex driver submission. Most of these
> > patches address the above issues; and the ioctl multiple abstraction
> > layers and the static forward declarations as you commented in another
> > e-mail. Some other patches are for code cleanups, mainly coding style.
> 
> I've only loosely followed these patches, but I'm sure the driver is in
> *much* better shape now. If you think you're done, it'd be worthwhile to
> just resubmit the entire driver in its new version.
> 
> johannes

Agreed -- please resubmit the driver as either a single patch
for inclusion or possibly as a small series of patches grouped by
functionality for further review.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
