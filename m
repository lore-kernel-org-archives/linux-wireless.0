Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34838 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab1H2TPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 15:15:23 -0400
Date: Mon, 29 Aug 2011 15:10:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/3] nl80211/cfg80211: add WIPHY_FLAG_AP_UAPSD flag
Message-ID: <20110829191023.GC1406@tuxdriver.com> (sfid-20110829_211539_871340_3DC2CF21)
References: <1314271494-8756-1-git-send-email-eliad@wizery.com>
 <1314624302.8959.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1314624302.8959.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 03:25:02PM +0200, Johannes Berg wrote:
> On Thu, 2011-08-25 at 14:24 +0300, Eliad Peller wrote:
> > add WIPHY_FLAG_AP_UAPSD flag to indicate uapsd support on
> > AP mode.
> > 
> > Advertise it to userspace by including a new
> > NL80211_ATTR_SUPPORT_AP_UAPSD attribute.
> 
> I guess it'll help me support this for mac80211 (drivers that don't do
> it all in firmware) -- I had a patch that was equivalent to the first
> two :)

Apparently I misinterpreted the discussion of the first version of
this series.  Apparently as Eliad was posting the 2nd version, I was
merging the first.

Could you post a version that takes what is already in wireless-next
and transforms it into this?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
