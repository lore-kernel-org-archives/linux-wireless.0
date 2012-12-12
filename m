Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2LLL0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 06:26:55 -0500
Message-ID: <1355311635.9708.3.camel@jlt4.sipsolutions.net> (sfid-20121212_122658_063670_A5B89234)
Subject: Re: [PATCH 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 12 Dec 2012 12:27:15 +0100
In-Reply-To: <1355311595.9708.2.camel@jlt4.sipsolutions.net> (sfid-20121212_122620_162346_E59A9D73)
References: <1354880763-12309-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1354880763-12309-2-git-send-email-vthiagar@qca.qualcomm.com>
	 <1355255841.9819.18.camel@jlt4.sipsolutions.net>
	 <50C81331.9080304@qca.qualcomm.com>
	 <1355311595.9708.2.camel@jlt4.sipsolutions.net>
	 (sfid-20121212_122620_162346_E59A9D73)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 12:26 +0100, Johannes Berg wrote:

> Yeah but I don't think that's a valid general assumption, and with the
> feature advertising API that you came up with, the driver can't
> advertise that it supports both at the same time etc.
> 
> Also, in fact, I think there needs to be more justification for why you
> need two lists to start with -- it seems to me that a white- and
> blacklist doesn't make sense at all, unless it's not really a white- and
> blacklist but one of
>  1) a blacklist
>  2) a whitelist + a "do not notify" list

And actually, without a notify mechanism (which I don't think exists
yet) this doesn't make sense anyway

johannes

