Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45147 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbcDUNCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 09:02:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: remove VHT capabilities from 2.4GHz
References: <1459850926-32264-1-git-send-email-johannes@sipsolutions.net>
Date: Thu, 21 Apr 2016 16:02:22 +0300
In-Reply-To: <1459850926-32264-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Tue, 5 Apr 2016 12:08:46 +0200")
Message-ID: <87eg9zcdy9.fsf@kamboji.qca.qualcomm.com> (sfid-20160421_150234_310566_1D4953E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> According to the spec, VHT doesn't exist in 2.4GHz.
>
> There are vendor extensions to allow a subset of VHT to work
> (notably 256-QAM), but since mac80211 doesn't support those
> advertising VHT capability on 2.4GHz leads to the behaviour
> of reporting VHT capabilities but not being able to use any
> of them due to mac80211's code requiring 80 MHz support.
>
> Remove the VHT capabilities from 2.4GHz for now. If mac80211
> gets extended to use the (likely Broadcom) vendor IEs for it
> and handles the lack of 80 MHz support, it can be added back.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

I'll resend this and CC ath10k list.

-- 
Kalle Valo
