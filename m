Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34889 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaK0Ose (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 09:48:34 -0500
Message-ID: <1417099707.19919.0.camel@sipsolutions.net> (sfid-20141127_154837_971583_DFC599AB)
Subject: Re: [PATCH] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Date: Thu, 27 Nov 2014 15:48:27 +0100
In-Reply-To: <1417095547-12197-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141127_143909_752029_5E7F4D1F)
References: <1417095547-12197-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20141127_143909_752029_5E7F4D1F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-27 at 14:39 +0100, Lorenzo Bianconi wrote:
> Configure per packet Transmit Power Control (TPC) in lower drivers checking
> if user_power_level has been set to IEEE80211_UNSET_POWER_LEVEL

Err, what? Why? how? what does this do?

johannes

