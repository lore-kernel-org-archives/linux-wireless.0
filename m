Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57916 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaEZI1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 04:27:25 -0400
Message-ID: <1401092831.19055.3.camel@jlt4.sipsolutions.net> (sfid-20140526_102741_603600_B11C6A4C)
Subject: Re: [PATCH] mac80211: fix virtual monitor interface addition
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 May 2014 10:27:11 +0200
In-Reply-To: <1401021341-26402-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1401021341-26402-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-05-25 at 15:35 +0300, Emmanuel Grumbach wrote:
> Since the commit below, cfg80211_chandef_dfs_required()
> will warn if it gets a an NL80211_IFTYPE_UNSPECIFIED iftype
> as explicitely written in the commit log.
> When an virtual monitor interface is added, its type is set
> in ieee80211_sub_if_data.vif.type, but not in
> ieee80211_sub_if_data.wdev.iftype which is passed to
> cfg80211_chandef_dfs_required() hence resulting in the
> following warning:

[...]

Applied, thanks.

johannes

