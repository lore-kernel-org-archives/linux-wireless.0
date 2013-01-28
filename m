Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab3A1MPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 07:15:40 -0500
Message-ID: <1359375363.8120.9.camel@jlt4.sipsolutions.net> (sfid-20130128_131543_934538_7260CECA)
Subject: Re: [PATCH] mac80211: fix mesh_sta_info_get() reshuffle damage
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 28 Jan 2013 13:16:03 +0100
In-Reply-To: <1359248402-6595-1-git-send-email-thomas@cozybit.com> (sfid-20130127_020104_978679_4E88F644)
References: <1359248402-6595-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130127_020104_978679_4E88F644)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-01-26 at 17:00 -0800, Thomas Pedersen wrote:
> Before "mac80211: clean up mesh sta allocation warning"
> was applied, mesh_sta_info_get() was reshuffled to please
> sparse. As a result we neglect to initialize newly created
> STAs. Fix this.

Ouch, sorry. Applied.

johannes

