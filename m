Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46438 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757963Ab2JaPyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 11:54:09 -0400
Message-ID: <1351698883.10946.3.camel@jlt4.sipsolutions.net> (sfid-20121031_165414_124168_284A5825)
Subject: Re: [PATCH 3.7] mac80211: do not call ieee80211_configure_filter if
 no interfaces are up
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 31 Oct 2012 16:54:43 +0100
In-Reply-To: <1351695034-74874-1-git-send-email-nbd@openwrt.org>
References: <1351695034-74874-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-31 at 15:50 +0100, Felix Fietkau wrote:
> Drivers are not expected to handle it before drv_start has been called. It
> will be called again after an interface has been brought up.

Applied, thanks.

johannes

