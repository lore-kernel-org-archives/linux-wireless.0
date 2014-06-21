Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37230 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaFUWTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 18:19:44 -0400
Date: Sun, 22 Jun 2014 00:19:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bing Zhao <bzhao@marvell.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH] Revert "mwifiex: Use the proper interfaces"
In-Reply-To: <1403309262-5737-1-git-send-email-bzhao@marvell.com>
Message-ID: <alpine.DEB.2.10.1406220013470.5170@nanos> (sfid-20140622_002009_789710_4F459496)
References: <1403309262-5737-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 20 Jun 2014, Bing Zhao wrote:

> This reverts commit a82fc3b4a2bceb7c6587249cb690342eb5065979.
> 
> Thomas corrected me on that I misunderstood Johannes' comment
> for net_timedelta() and the ktime_get_real() usage inside
> __net_timestamp().

And still my V2 patch is functionally equivivalent to the current
implementation but uses the proper interfaces for that.

If the network core folks come up with a clock monotonic based
solution, then you do not have to change anything at all. It just
works ...

That's what interfaces are made for....

Thanks,

	tglx
