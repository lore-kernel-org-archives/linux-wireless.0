Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39890 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946671Ab3BHRKx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:10:53 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: introduce beacon-only timing data
References: <1360160966-26163-1-git-send-email-johannes@sipsolutions.net>
Date: Fri, 08 Feb 2013 19:10:52 +0200
In-Reply-To: <1360160966-26163-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Wed, 6 Feb 2013 15:29:26 +0100")
Message-ID: <87k3qibujn.fsf@purkki.adurom.net> (sfid-20130208_181058_987298_42D966C2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm getting seriously behind email, but...

Johannes Berg <johannes@sipsolutions.net> writes:

> In order to be able to predict the next DTIM TBTT
> in the driver, add the ability to use timing data
> from beacons only with the new hardware flag
> IEEE80211_HW_TIMING_BEACON_ONLY and the BSS info
> value sync_dtim_count which is only valid if the
> timing data came from a beacon. The data can only
> come from a beacon, and if no beacon was received
> before association it is updated later together
> with the DTIM count notification.

Just out of curiosity, who uses this?

-- 
Kalle Valo
