Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39106 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3HINO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 09:14:56 -0400
Message-ID: <1376054092.8355.6.camel@jlt4.sipsolutions.net> (sfid-20130809_151458_774743_3818D6D4)
Subject: Re: [PATCH] iw: correction in coalesce condition display message
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 09 Aug 2013 15:14:52 +0200
In-Reply-To: <1375740366-8986-1-git-send-email-bzhao@marvell.com>
References: <1375740366-8986-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-08-05 at 15:06 -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> NL80211_COALESCE_CONDITION_MATCH is 0 and
> NL80211_COALESCE_CONDITION_NO_MATCH is 1.
> Hence this change is required

Pretty weird, but ok. Maybe asking to give "match" or "no-match" in the
file would have been better.

Applied.

johannes

