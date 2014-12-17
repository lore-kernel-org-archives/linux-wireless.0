Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36132 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbaLQKrw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:47:52 -0500
Message-ID: <1418813269.2135.6.camel@sipsolutions.net> (sfid-20141217_114755_489919_34C789E7)
Subject: Re: [PATCH] mac80211: notify channel switch at the end of
 ieee80211_chswitch_post_beacon()
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Wed, 17 Dec 2014 11:47:49 +0100
In-Reply-To: <1418738499-4488-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1418738499-4488-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-16 at 16:01 +0200, Emmanuel Grumbach wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> The call to cfg80211_ch_switch_notify() should be at the end of the
> ieee80211_chswitch_post_beacon() function, because it should only be
> sent if everything succeeded.

Applied.

johannes

