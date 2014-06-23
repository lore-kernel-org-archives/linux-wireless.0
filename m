Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25277 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755484AbaFWTX1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 15:23:27 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>
Date: Mon, 23 Jun 2014 12:23:11 -0700
Subject: RE: [PATCH] Revert "mwifiex: Use the proper interfaces"
Message-ID: <477F20668A386D41ADCC57781B1F70430FE56129EB@SC-VEXCH1.marvell.com> (sfid-20140623_212330_430664_82C9A699)
References: <1403309262-5737-1-git-send-email-bzhao@marvell.com>
 <alpine.DEB.2.10.1406220013470.5170@nanos>
In-Reply-To: <alpine.DEB.2.10.1406220013470.5170@nanos>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas,

> > This reverts commit a82fc3b4a2bceb7c6587249cb690342eb5065979.
> >
> > Thomas corrected me on that I misunderstood Johannes' comment
> > for net_timedelta() and the ktime_get_real() usage inside
> > __net_timestamp().
> 
> And still my V2 patch is functionally equivivalent to the current
> implementation but uses the proper interfaces for that.

Yes, your v2 patch is equivalent to the current code using the proper interfaces.
It also makes the code simpler and cleaner. Thanks!

Hi John,

Could you please apply the v2 patch titled "[patch V2] wireless: mwifiex: Use the proper interfaces" after applying this "revert" patch?

Thanks,
Bing

> 
> If the network core folks come up with a clock monotonic based
> solution, then you do not have to change anything at all. It just
> works ...
> 
> That's what interfaces are made for....
> 
> Thanks,
> 
> 	tglx
