Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1IEMIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:08:36 -0400
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315224151-16552-4-git-send-email-VictorG@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 14:08:32 +0200
Message-ID: <1315224512.4075.10.camel@jlt3.sipsolutions.net> (sfid-20110905_140838_462729_B6B2E8B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-05 at 15:02 +0300, Victor Goldenshtein wrote:
> Adding intermediate scan result event by exposing new
> NL80211_CMD_IM_SCAN_RESULT event, which will contain
> NL80211_BSS_BSSID to specify the BSSID of received scan result and
> NL80211_BSS_SIGNAL_MBM to indicate signal strength.
> 
> This event might be optionally enabled during
> NL80211_CMD_TRIGGER_SCAN, with NL80211_ATTR_IM_SCAN_RESULT
> flag attribute.

Also, this feature needs to be discoverable somehow, I think?

johannes

