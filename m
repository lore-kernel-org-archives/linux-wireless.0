Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1AYN5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 08:57:08 -0500
Subject: Re: [PATCH] cfg80211: Allow non-zero indexes for device specific
 pair-wise ciphers
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1295963224.18570.367.camel@wimaxnb.nmp.nokia.com>
References: <1295950882-16785-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1295951230.3650.8.camel@jlt3.sipsolutions.net>
	 <1295963224.18570.367.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 14:57:03 +0100
Message-ID: <1295963823.3625.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-25 at 15:47 +0200, Juuso Oikarinen wrote:

> I would be surprised to see WAPI used with CCMP though - or any other
> voluntary manner for that matter - although it is possible ;)

:)

> So you think this patch is ok as is, or do I need to find some other
> way?

I guess it's fine -- I was trying to figure out what they tried to do
with the key index but the WAPI "standard" is kinda vague on that ...

johannes

