Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3477 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965620AbXBGBOp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 20:14:45 -0500
Date: Tue, 6 Feb 2007 19:46:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC v2] cfg80211 merge
Message-ID: <20070207004626.GA23096@tuxdriver.com>
References: <20070131013717.GA28076@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070131013717.GA28076@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In London we agreed that it would be good to go ahead and merge
cfg80211.  This provides some exposure to the API and eases some of
the pain for driver maintainers (who won't have to follow wireless-dev
to get it).  It also adds the ieee80211_ptr to the net_device struct.

I have refactored the cfg80211-related patches down to three patches.
This eliminates some of the churn in the series from wireless-dev,
and each patch leaves a buildable tree.  This version also removes
the nl80211 bits to a separate patch (available in wireless-dev on
the mm-master branch).
 
Let me know if I've left anything out, screwed anything up, etc...

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
