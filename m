Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55907 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab0DLVDr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 17:03:47 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] nl80211: Add support for dynamic ps timeout configuration
References: <1271059902-27788-1-git-send-email-juuso.oikarinen@nokia.com>
	<1271061120.3877.6.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 12 Apr 2010 23:19:35 +0300
In-Reply-To: <1271061120.3877.6.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Mon\, 12 Apr 2010 10\:32\:00 +0200")
Message-ID: <878w8spgo8.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2010-04-12 at 11:11 +0300, Juuso Oikarinen wrote:
>> This adds support to configure the dynamic ps timeout via nl80211. The
>> relevant attribute is added to NL80211_CMD_SET_POWER_SAVE.
>
> I'm not sure we even want this.

When I added power save support to nl80211, I deliberately left out
setting the timeout. In the future there will be more advanced methods
to control power save and the timeout value would be then meaningless.

-- 
Kalle Valo
