Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab1HaHOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 03:14:52 -0400
Subject: Re: [RFC] nl80211: Added NL80211 commands for Bluetooth-WiFi coex
From: Johannes Berg <johannes@sipsolutions.net>
To: Suraj Sumangala <surajs@qca.qualcomm.com>
Cc: linville@tuxdriver.com, ath6kl-devel@qualcomm.com,
	senthilb@qca.qualcomm.com, vipimeht@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
References: <1314771915-8848-1-git-send-email-surajs@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 09:14:43 +0200
Message-ID: <1314774883.4161.18.camel@jlt3.sipsolutions.net> (sfid-20110831_091455_453892_073FC4F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 11:55 +0530, Suraj Sumangala wrote:


> +	NL80211_CMD_BTCOEX_INQ,
> +	NL80211_CMD_BTCOEX_SCO,
> +	NL80211_CMD_BTCOEX_A2DP,
> +	NL80211_CMD_BTCOEX_ACL_ROLE,

Why do you need all these commands and not just one BT config command
that gives everything? Need to see more of the implementation but that
seems pointless.

johannes

