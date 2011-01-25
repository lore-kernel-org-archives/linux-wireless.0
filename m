Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab1AYK2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 05:28:35 -0500
Subject: Re: [PATCH] cfg80211: Allow non-zero indexes for device specific
 pair-wise ciphers
From: Johannes Berg <johannes@sipsolutions.net>
To: juuso.oikarinen@nokia.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1295950882-16785-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1295950882-16785-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 11:28:30 +0100
Message-ID: <1295951310.3650.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-25 at 12:21 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Some vendor specific cipher suites require non-zero key indexes for pairwise
> keys, but as of currently, the cfg80211 does not allow it.

Hmm, also -- does this mean that WAPI might use multiple pairwise keys?
That's most definitely not supported at all in mac80211.

johannes

