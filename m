Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56047 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1HLMad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 08:30:33 -0400
Subject: Re: [PATCH 3/3] nl80211/cfg80211: Add extra IE configuration to AP
 mode setup
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110810205556.GA3821@jouni.qca.qualcomm.com>
References: <20110810205556.GA3821@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 14:30:28 +0200
Message-ID: <1313152228.4022.4.camel@jlt3.sipsolutions.net> (sfid-20110812_143036_495384_D9D752EE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 23:55 +0300, Jouni Malinen wrote:
> The NL80211_CMD_NEW_BEACON command is, in practice, requesting AP mode
> operations to be started. Add new attributes to provide extra IEs
> (e.g., WPS IE, P2P IE) for drivers that build Beacon, Probe Response,
> and (Re)Association Response frames internally (likely in firmware).

Out of curiosity, how would such a driver implement WPS to start with?

johannes

