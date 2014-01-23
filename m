Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaAWIRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 03:17:44 -0500
Message-ID: <1390465052.4142.0.camel@jlt4.sipsolutions.net> (sfid-20140123_091747_518698_5F5A5E23)
Subject: Re: [PATCH] nl80211: Count only ssid attr to know number of match
 sets
From: Johannes Berg <johannes@sipsolutions.net>
To: Raja Mani <rmani@qti.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 09:17:32 +0100
In-Reply-To: <1390451229-3308-1-git-send-email-rmani@qti.qualcomm.com>
References: <1390451229-3308-1-git-send-email-rmani@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 09:57 +0530, Raja Mani wrote:
> NL80211_ATTR_SCHED_SCAN_MATCH can have NL80211_SCHED_SCAN_MATCH_ATTR_SSID
> as well as NL80211_SCHED_SCAN_MATCH_ATTR_RSSI in it. Each nested attributes
> which are part of NL80211_ATTR_SCHED_SCAN_MATCH are counted to find out
> number of match sets in nl80211_start_sched_scan().
> 
> This is the problem if NL80211_SCHED_SCAN_MATCH_ATTR_RSSI also part of
> NL80211_ATTR_SCHED_SCAN_MATCH. Fix this incorrect calculation by considering
> only NL80211_SCHED_SCAN_MATCH_ATTR_SSID to know match set count.

Err, you failed to explain *why* this is a problem. I'm not even
convinced you're right anyway.

johannes

