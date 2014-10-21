Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45463 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369AbaJUTiR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 15:38:17 -0400
Message-ID: <1413920294.1998.22.camel@jlt4.sipsolutions.net> (sfid-20141021_213820_789805_DA9C83EA)
Subject: Re: [PATCH v2 4/6] cfg80211: support creating wiphy w/out creating
 wlanX.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Oct 2014 21:38:14 +0200
In-Reply-To: <1413845378-27837-4-git-send-email-greearb@candelatech.com>
References: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
	 <1413845378-27837-4-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This isn't a cfg80211 patch (subject)

> + * @IEEE80211_HW_NO_AUTO_VDEV: The driver would like for no wlanX to
> + *	be created.  It is expected user-space will create vdevs as
> + *      desired (and thus have them named as desired).

"VDEV" isn't a term mac80211 uses anywhere, please use "VIF" or similar
- no need to add more terminology.
johannes

