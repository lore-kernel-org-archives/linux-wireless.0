Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab1BNMJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 07:09:30 -0500
Subject: Re: [RFC v2 1/2] mac80211: add a function for setting the TIM bit
 for a specific station
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, lrodriguez@atheros.com,
	m.sujith@gmail.com
In-Reply-To: <1297207937-88528-1-git-send-email-nbd@openwrt.org>
References: <1297207937-88528-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 13:09:27 +0100
Message-ID: <1297685367.3785.33.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-09 at 00:32 +0100, Felix Fietkau wrote:
> When a driver wants to buffer some frames internally without feeding them
> back to mac80211, this allows it to still wake up the station

Why would the driver want to do this though?

johannes

