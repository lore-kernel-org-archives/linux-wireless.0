Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42496 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab0JOFvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 01:51:00 -0400
Subject: Re: [PATCH 1/2] cfg80211: Add cfg80211/nl80211 calls for bitrate
 threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20101014224326.8B175203B2@glenhelen.mtv.corp.google.com>
References: <20101014224326.8B175203B2@glenhelen.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 07:51:42 +0200
Message-ID: <1287121902.3640.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-14 at 14:35 -0700, Paul Stewart wrote:

> + * @NL80211_ATTR_CQM_BITRATE_THOLD: Bitrate threshold in 1000 bits per second.
> + *      This specifies the threshold at which an event will be sent.  Set to
> + *      zero to disable.

Is it a low or a high threshold? Or should it notify whenever this is
crossed in both directions? I think you should document that as well.

johannes

