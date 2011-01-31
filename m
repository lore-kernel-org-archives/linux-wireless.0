Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab1AaLYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:24:05 -0500
Subject: Re: [PATCH v2 06/10] mac80211: add HW flag for disabling auto
 link-PS in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1296472589-26401-7-git-send-email-arik@wizery.com>
References: <1296472589-26401-1-git-send-email-arik@wizery.com>
	 <1296472589-26401-7-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 12:24:03 +0100
Message-ID: <1296473043.3812.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It'd be nicer if you could separate out mac80211 patches, but then Luca
needs to hold off merging until John picked up the mac80211 patch.

> + * @IEEE80211_HW_AP_LINK_PS: When operating in AP mode the device
> + *	autonomously manages the PS status of connected stations. When
> + *	this flag is set mac80211 will not trigger PS mode for connected
> + *	stations based on the PM bit of incoming frames.
> + *	Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
> + *	the PS mode of connected stations.

You just renamed it.

Also, come to think of it, the ieee80211_sta_block_awake will not be
effective I think? Or will it?

johannes

