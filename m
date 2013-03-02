Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3CBUZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 15:25:14 -0500
Message-ID: <1362255909.10096.3.camel@jlt4.sipsolutions.net> (sfid-20130302_212518_859653_33FE11A1)
Subject: Re: [PATCH 3.9] mac80211: another fix for idle handling in monitor
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 02 Mar 2013 21:25:09 +0100
In-Reply-To: <1362247547-71096-1-git-send-email-nbd@openwrt.org>
References: <1362247547-71096-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-03-02 at 19:05 +0100, Felix Fietkau wrote:
> When setting a monitor interface up or down, the idle state needs to be
> recalculated, otherwise the hardware will just stay in its previous idle
> state.

Applied.

johannes

