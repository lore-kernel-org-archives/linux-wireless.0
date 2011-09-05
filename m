Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1IEMFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:05:48 -0400
Subject: Re: [RFC v2 1/5] nl80211/cfg80211: adding 'scan_cancel' command.
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315224151-16552-2-git-send-email-VictorG@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-2-git-send-email-VictorG@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 14:05:43 +0200
Message-ID: <1315224343.4075.7.camel@jlt3.sipsolutions.net> (sfid-20110905_140557_218411_71B23E20)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-05 at 15:02 +0300, Victor Goldenshtein wrote:
> Mostly from an energy consumption and cpu load perspective,
> it can be useful to stop a triggered scan earlier, when one
> finds the desired scan results.
> Adding the ability to stop a scan from user space by exposing
> new NL80211_CMD_SCAN_CANCEL API.

Would be nice to advertise availability, possibly through mac80211?

johannes

