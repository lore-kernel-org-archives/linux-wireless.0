Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46522 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZA3Spt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 13:45:49 -0500
Date: Fri, 30 Jan 2009 13:36:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
Subject: Re: [PATCH] mac80211: convert to net_device_ops
Message-ID: <20090130183615.GF3485@tuxdriver.com> (sfid-20090130_194553_550322_4BE35A83)
References: <20090127052926.44d3fd5f@s6510> <1233314257.30970.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1233314257.30970.6.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 12:17:37PM +0100, Johannes Berg wrote:
> On Tue, 2009-01-27 at 05:29 +1100, Stephen Hemminger wrote:
> > Convert to new net_device_ops in 2.6.28 and later.
> > 
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> John, please revert this commit for now, it's breaking monitor mode
> injection (and thus AP mode) because the xmit handler assignment in
> ieee80211_setup_sdata is not effective.

Ok, done.  I reverted the hostap one as well, as I think it is
incomplete and could use more review.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
