Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58811 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcFBNpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 09:45:23 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: remove duplicate and unused rx rate flags
Date: Thu, 2 Jun 2016 13:45:15 +0000
Message-ID: <87a8j3zout.fsf@kamboji.qca.qualcomm.com> (sfid-20160602_154529_535321_5F7182B4)
References: <1464852235-13110-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1464852235-13110-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Thu, 2 Jun 2016 12:53:54	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> All these flags are not used and their use is completely
> covered by 'ath10k_hw_rate_ofdm', 'ath10k_hw_rate_cck',
> and RX_PPDU_START_RATE_FLAG
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> Patchwork-Id: 9129361
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

I guess you took this patch from the pending branch? :) The Patchwork-Id
line is something which my script adds for patches in the pending
branch, and removes them before applying them to ath-next, but this line
should not be visible when submitting patches.

-- 
Kalle Valo