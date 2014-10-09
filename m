Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57059 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbaJIJCT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:02:19 -0400
Message-ID: <1412845335.1828.26.camel@jlt4.sipsolutions.net> (sfid-20141009_110224_140057_051D4A52)
Subject: Re: [PATCH] mac80211: return the vif's chandef in
 ieee80211_cfg_get_channel()
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Thu, 09 Oct 2014 11:02:15 +0200
In-Reply-To: <1412050082-7763-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1412050082-7763-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-30 at 07:08 +0300, Emmanuel Grumbach wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> The chandef of the channel context a vif is using may be different
> than the chandef of the vif itself.  For instance, the bandwidth used
> by the vif may be narrower than the one configured in the channel
> context.  To avoid confusion, return the vif's chandef in
> ieee80211_cfg_get_channel() instead of the chandef of the channel
> context.

Applied.

johannes

