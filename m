Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab1EaTcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:32:39 -0400
Subject: Re: [PATCH 2/3] mac80211: create a STA entry for a WDS interface
 after receiving a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1306869394-83047-2-git-send-email-nbd@openwrt.org>
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>
	 <1306869394-83047-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 21:32:34 +0200
Message-ID: <1306870354.29989.1.camel@jlt3.sipsolutions.net> (sfid-20110531_213242_956576_80A6CA5D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-31 at 21:16 +0200, Felix Fietkau wrote:
> When a STA entry is created too early, a lot of essential information
> required for rate control is missing.

I don't understand how you can rely on beacons for WDS.

johannes

