Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55451 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaFYUAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:00:13 -0400
Date: Wed, 25 Jun 2014 15:56:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH] Revert "mwifiex: Use the proper interfaces"
Message-ID: <20140625195633.GK3445@tuxdriver.com> (sfid-20140625_220025_996871_91F24BD0)
References: <1403309262-5737-1-git-send-email-bzhao@marvell.com>
 <alpine.DEB.2.10.1406220013470.5170@nanos>
 <477F20668A386D41ADCC57781B1F70430FE56129EB@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430FE56129EB@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2014 at 12:23:11PM -0700, Bing Zhao wrote:
> Hi Thomas,
> 
> > > This reverts commit a82fc3b4a2bceb7c6587249cb690342eb5065979.
> > >
> > > Thomas corrected me on that I misunderstood Johannes' comment
> > > for net_timedelta() and the ktime_get_real() usage inside
> > > __net_timestamp().
> > 
> > And still my V2 patch is functionally equivivalent to the current
> > implementation but uses the proper interfaces for that.
> 
> Yes, your v2 patch is equivalent to the current code using the proper interfaces.
> It also makes the code simpler and cleaner. Thanks!
> 
> Hi John,
> 
> Could you please apply the v2 patch titled "[patch V2] wireless: mwifiex: Use the proper interfaces" after applying this "revert" patch?
> 
> Thanks,
> Bing

OK, doing that now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
