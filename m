Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55442 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbbKCJiZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 04:38:25 -0500
Message-ID: <1446543502.29010.7.camel@sipsolutions.net> (sfid-20151103_104116_640748_CF8468CB)
Subject: Re: [PATCH 08/10] mac80211: Remove WARN_ON_ONCE in
 ieee80211_recalc_smps
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Tue, 03 Nov 2015 10:38:22 +0100
In-Reply-To: <1445763582-11421-8-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1445763582-11421-8-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-10-25 at 10:59 +0200, Emmanuel Grumbach wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> The recalc_smps work can run after the station disassociates.
> At this stage we already released the channel, but the work
> will be cancelled only when the interface stops.
> In this scenario we can hit the warning in ieee80211_recalc_smps, so
> just remove it.
> 
Applied.

johannes
