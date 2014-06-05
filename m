Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57341 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaFEPPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 11:15:11 -0400
Date: Thu, 5 Jun 2014 11:14:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] cfg80211: make ethtool the driver's responsibility
Message-ID: <20140605151440.GB3621@tuxdriver.com> (sfid-20140605_171515_882388_FD9181FC)
References: <1401896290-12942-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401896290-12942-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 04, 2014 at 05:38:10PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Currently, cfg80211 tries to implement ethtool, but that doesn't
> really scale well, with all the different operations. Make the
> lower-level driver responsible for it, which currently only has
> an effect on mac80211. It will similarly not scale well at that
> level though, since mac80211 also has many drivers.
> 
> To cleanly implement this in mac80211, introduce a new file and
> move some code to appropriate places.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Fine by me...

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
