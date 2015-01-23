Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35466 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbbAWJwB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 04:52:01 -0500
Message-ID: <1422006718.2728.16.camel@sipsolutions.net> (sfid-20150123_105204_044200_35222AF5)
Subject: Re: [PATCHv5] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de
Date: Fri, 23 Jan 2015 10:51:58 +0100
In-Reply-To: <1421236508-9055-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150114_125510_488289_CE9A9C1E)
References: <1421236508-9055-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20150114_125510_488289_CE9A9C1E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-14 at 12:55 +0100, Lorenzo Bianconi wrote:
> Control per packet Transmit Power Control (TPC) in lower drivers
> according to TX power settings configured by the user. In particular TPC is
> enabled if value passed in enum nl80211_tx_power_setting is
> NL80211_TX_POWER_LIMITED (allow using less than specified from userspace),
> whereas TPC is disabled if nl80211_tx_power_setting is set to
> NL80211_TX_POWER_FIXED (use value configured from userspace)

Applied.

johannes

