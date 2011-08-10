Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60494 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1HJU24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 16:28:56 -0400
Subject: Re: [PATCH 1/2] mac80211: make ieee80211_send_bar available for
 drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
In-Reply-To: <1313005527-83182-1-git-send-email-nbd@openwrt.org>
References: <1313005527-83182-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 22:28:51 +0200
Message-ID: <1313008131.4016.3.camel@jlt3.sipsolutions.net> (sfid-20110810_222859_174522_A95E1361)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-10 at 13:45 -0600, Felix Fietkau wrote:

> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + * @ra: the peer's destination address
> + * @tid: the TID of the aggregation session
> + * @ssn: the new starting sequence number for the receiver

might want to say that ssn is with fragno in it :)

johannes

