Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56599 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbcCCPkl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:40:41 -0500
Message-ID: <1457019637.2044.26.camel@sipsolutions.net> (sfid-20160303_164044_672551_1068C80A)
Subject: Re: [PATCH 3/3] mac80211: recalc min_def chanctx even when chandef
 is identical
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Thu, 03 Mar 2016 16:40:37 +0100
In-Reply-To: <1456954113-4682-3-git-send-email-emmanuel.grumbach@intel.com>
References: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1456954113-4682-3-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All three applied, but I had to fix your Fixes tag commit ID, no idea
what that referred to :)

johannes
