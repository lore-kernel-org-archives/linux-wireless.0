Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53316 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935107AbeFMLni (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 07:43:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: Added support for Dell Wireless 1537 which is an Qualcomm Atheros
 AR6004X with an sdio ID of 0x19. hardware ID is 0271:0419. And tested it on a
 Dell Venue 11 Pro 7130 with a compiled kernel.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180521212644.7838-1-guylovesbritt@gmail.com>
References: <20180521212644.7838-1-guylovesbritt@gmail.com>
To: Guy Chronister <guylovesbritt@gmail.com>
Cc: linux-wireless@vger.kernel.org, guychronister@outlook.com,
        Guy Chronister <guylovesbritt@gmail.com>
Message-Id: <20180613114338.5D7786074D@smtp.codeaurora.org> (sfid-20180613_134343_615874_2505E567)
Date: Wed, 13 Jun 2018 11:43:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Chronister <guylovesbritt@gmail.com> wrote:

> This is a Qualcomm Atheros AR6004X with an sdio ID of 0x19 and hardware ID of
> 0271:0419. Tested on a Dell Venue 11 Pro 7130 with a self compiled kernel.
> 
> Signed-off-by: Guy Chronister <guylovesbritt@gmail.com>
> [kvalo@codeaurora.org: cleanup commit log]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

87b466f42e8f ath6kl: add support for Dell Wireless 1537

-- 
https://patchwork.kernel.org/patch/10416657/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
