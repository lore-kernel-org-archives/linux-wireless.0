Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:43349 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3AIQGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 11:06:11 -0500
Message-ID: <50ED94F7.9000709@ti.com> (sfid-20130109_170620_417110_38C1C5DF)
Date: Wed, 9 Jan 2013 18:04:07 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix delayed ADDBA response
References: <1357654597-8493-1-git-send-email-victorg@ti.com> <1357735100.9757.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1357735100.9757.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/13 14:38, Johannes Berg wrote:
> Do we really want to allow arbitrary changes to the interfaces while
> scanning? This could process a deauth frame for example, I'm worried
> that might break things.
>

Can you please elaborate why we shouldn't process deauth frames during 
HW scan ? This fix was tested with our 18xx, don't see how it can break 
things, but it's up to you whether to take it..

-- 
Thanks,
Victor.
