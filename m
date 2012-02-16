Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35837 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2BPPVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 10:21:18 -0500
Subject: Re: [RFC] cfg80211: Add an attribute in NL80211_CMD_SET_INTERFACE
 for bgscan interval
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1329404518-14063-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1329404518-14063-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Feb 2012 16:21:13 +0100
Message-ID: <1329405673.3915.11.camel@jlt3.sipsolutions.net> (sfid-20120216_162140_166712_C5727697)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-16 at 20:31 +0530, Vasanthakumar Thiagarajan wrote:
> A new nl80211 netlink attribute %NL80211_ATTR_BGSCAN_INTERVAL in
> NL80211_CMD_SET_INTERFACE is an u16 and has the time interval in
> seconds at which the driver has to do the background scanning.
> This can be used by drivers which handles the scanning and
> roaming functionalities. Setting an interval of 0 may disable
> the bgscan.

Huh? No way. We already have bgscan with explicit configuration.

johannes


