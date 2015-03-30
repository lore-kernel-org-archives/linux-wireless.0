Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8705 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbbC3Nl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 09:41:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/4] ath10k: Fix no-ack frame status
References: <1418226973-13779-1-git-send-email-sujith@msujith.org>
	<1418226973-13779-3-git-send-email-sujith@msujith.org>
	<87oarazecg.fsf@kamboji.qca.qualcomm.com>
	<21646.15326.159197.316821@gargle.gargle.HOWL>
	<87vblduxlk.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 30 Mar 2015 16:41:48 +0300
In-Reply-To: <87vblduxlk.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Mon, 15 Dec 2014 10:27:19 +0200")
Message-ID: <87a8yu4n6r.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_154204_378937_FE4C582E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Discussion from last December)

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Sujith Manoharan <sujith@msujith.org> writes:
>
>> Kalle Valo wrote:
>>> Johannes, are you planning to take this? Or should I take this once the
>>> corresponding mac80211 patch trickles down to my tree?
>>
>> Kalle, can you please pick this one ? I'll rebase and send the ath9k patch
>> to John once he starts merging patches.
>
> Yes, I'll take this patch once I have the mac80211 dependency in my
> tree. I marked the patch as "Awaiting Upstream" in patchwork so that I
> don't forget, hopefully :)
>
> https://patchwork.kernel.org/patch/5470621/

Naturally I did forget this :) But the patch is in pending branch now.

-- 
Kalle Valo
