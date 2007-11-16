Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.172]:64264 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbXKPNUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 08:20:00 -0500
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <bruno@thinktube.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH] ath5k: consistent info and error logging
References: <1195200656-25847-1-git-send-email-bruno@thinktube.com>
	<1195214563.8147.118.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Fri, 16 Nov 2007 15:17:43 +0200
In-Reply-To: <1195214563.8147.118.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 16 Nov 2007 13\:02\:43 +0100")
Message-ID: <87mytez5vs.fsf@nokia.com> (sfid-20071116_132005_118835_568C3E3E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> +#define AR5K_INFO(_sc, _fmt, ...)	\
>> +	printk(KERN_INFO "ath5k %s: " _fmt, wiphy_name((_sc)->hw->wiphy), ##__VA_ARGS__)
>
> Eww. Can't you make them static inlines?

Wasn't it so that a inline function with va_args is not possible? 

I can be wrong, though.

-- 
Kalle Valo
