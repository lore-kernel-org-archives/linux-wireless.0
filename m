Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaDYPrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:47:16 -0400
Message-ID: <1398440818.4152.29.camel@jlt4.sipsolutions.net> (sfid-20140425_174720_773602_FB414093)
Subject: Re: [PATCH 7/7] cfg80211: implement cfg80211_get_station cfg80211
 API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Fri, 25 Apr 2014 17:46:58 +0200
In-Reply-To: <1397484205-20905-7-git-send-email-antonio@meshcoding.com>
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
	 <1397484205-20905-7-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	rdev = wiphy_to_dev(wdev->wiphy);

That's _to_rdev() now.

johannes


