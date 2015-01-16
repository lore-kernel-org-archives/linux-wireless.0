Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:41709 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbAPFuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 00:50:03 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, me@bobcopeland.com
Subject: Re: [PATCH] mesh: Avoid STA expiration timer truncation to u32
References: <1421385460-3126-1-git-send-email-masashi.honma@gmail.com>
Date: Fri, 16 Jan 2015 07:49:56 +0200
In-Reply-To: <1421385460-3126-1-git-send-email-masashi.honma@gmail.com>
	(Masashi Honma's message of "Fri, 16 Jan 2015 14:17:40 +0900")
Message-ID: <87iog7nukb.fsf@kamboji.qca.qualcomm.com> (sfid-20150116_065008_660798_1CB8A510)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Masashi Honma <masashi.honma@gmail.com> writes:

> On some combination of plink_timeout and HZ, the STA expiration timer will be
> unexpectedly truncated to u32. Maybe there is a question "Who sets such a large
> number to plink_timeout ?". At least wpa_supplicant will set 0xffffffff to
> plink_timeout to disable this timer because wpa_supplicant has it's own
> expiration mechanism.
>
> Signed-off-by: Masashi Honma <masashi.honma@gmail.com>

For mac80211 patches please use prefix "mac80211: ".

-- 
Kalle Valo
