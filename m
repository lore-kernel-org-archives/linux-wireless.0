Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:43125 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0A0HyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 02:54:24 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1422940eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 23:54:23 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	buytenh@wantstofly.org, wey-yi.w.guy@intel.com
Subject: Re: [PATCH] mac80211: wait for beacon before enabling powersave
References: <1264511993.25642.9.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 27 Jan 2010 09:54:20 +0200
In-Reply-To: <1264511993.25642.9.camel@johannes.local> (Johannes Berg's message of "Tue\, 26 Jan 2010 14\:19\:52 +0100")
Message-ID: <87r5pckmoj.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Because DTIM information is required for powersave
> but is only conveyed in beacons, wait for a beacon
> before enabling powersave, and change the way the
> information is conveyed to the driver accordingly.
>
> mwl8k doesn't currently seem to implement PS but
> requires the DTIM period in a different way; after
> talking to Lennert we agreed to just have mwl8k do
> the parsing itself in the finalize_join work.

I quickly tested with wl1251 on n900, works just fine.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

For the wl1251 part:

Acked-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
