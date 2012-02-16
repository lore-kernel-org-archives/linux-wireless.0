Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62744 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2BPQh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 11:37:28 -0500
From: "Thiagarajan, Vasanthakumar" <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] cfg80211: Add an attribute in NL80211_CMD_SET_INTERFACE
 for bgscan interval
Date: Thu, 16 Feb 2012 16:37:14 +0000
Message-ID: <EDA962D9696870498097087E0373E771B9F341@aphydexd01b> (sfid-20120216_173732_496366_56DDECB8)
References: <1329404518-14063-1-git-send-email-vthiagar@qca.qualcomm.com>,<1329405673.3915.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1329405673.3915.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Johannes Berg [johannes@sipsolutions.net]
Sent: Thursday, February 16, 2012 8:51 PM
To: Thiagarajan, Vasanthakumar
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: Add an attribute in NL80211_CMD_SET_INTERFACE for bgscan interval




On Thu, 2012-02-16 at 20:31 +0530, Vasanthakumar Thiagarajan wrote:
> A new nl80211 netlink attribute %NL80211_ATTR_BGSCAN_INTERVAL in
> NL80211_CMD_SET_INTERFACE is an u16 and has the time interval in
> seconds at which the driver has to do the background scanning.
> This can be used by drivers which handles the scanning and
> roaming functionalities. Setting an interval of 0 may disable
> the bgscan.

> Huh? No way. We already have bgscan with explicit configuration.

Oops, I think you are referring to NL80211_CMD_START_SCHED_SCAN?,
i'll use this, thanks.

Vasanth
 





























































johannes


