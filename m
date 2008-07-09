Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58444 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbYGIN3p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:29:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/4] mac80211: revamp beacon configuration
Date: Wed, 9 Jul 2008 15:29:20 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>
References: <20080709124033.781606000@sipsolutions.net> <20080709124255.193524000@sipsolutions.net>
In-Reply-To: <20080709124255.193524000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807091529.20656.mb@bu3sch.de> (sfid-20080709_152948_399060_95678B02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008 14:40:37 Johannes Berg wrote:
> This patch changes mac80211's beacon configuration handling
> to never pass skbs to the driver directly but rather always
> require the driver to use ieee80211_beacon_get(). Additionally,
> it introduces "change flags" on the config_interface() call
> to enable drivers to figure out what is changing. Finally, it
> removes the beacon_update() driver callback in favour of
> having IBSS beacon delivered by ieee80211_beacon_get() as well.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---

>  drivers/net/wireless/b43/main.c             |   48 +++++-------
>  drivers/net/wireless/b43legacy/main.c       |   45 ++++-------

ACK

-- 
Greetings Michael.
