Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2FUOnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:43:06 -0400
Message-ID: <1340289782.4489.26.camel@jlt3.sipsolutions.net> (sfid-20120621_164310_245360_BEBCB645)
Subject: Re: [PATCH v5] mac80211: add command to get current rssi
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Jun 2012 16:43:02 +0200
In-Reply-To: <1340265406-25099-1-git-send-email-victorg@ti.com>
References: <1340265406-25099-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-21 at 10:56 +0300, Victor Goldenshtein wrote:
> Get current rssi (in dBm) from the driver/FW.
> 
> Instead of reporting the signal received in the last
> rx packet, which might be inaccurate if rx traffic is
> low and beacon filtering is enabled, get the singal
> from the driver/FW.

Applied, thanks for your patience :)

johannes

