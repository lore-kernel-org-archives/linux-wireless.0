Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50284 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933775AbeBMJGY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 04:06:24 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 3/3] ath: change in cfg80211_probe_status API
References: <1518500128-10837-1-git-send-email-vnaralas@codeaurora.org>
Date: Tue, 13 Feb 2018 11:06:20 +0200
In-Reply-To: <1518500128-10837-1-git-send-email-vnaralas@codeaurora.org>
        (Venkateswara Naralasetty's message of "Tue, 13 Feb 2018 11:05:28
        +0530")
Message-ID: <87inb1p8c3.fsf@purkki.adurom.net> (sfid-20180213_100634_731425_9E2B381C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Venkateswara Naralasetty <vnaralas@codeaurora.org> writes:

> This patch changes cfg80211_probe_status API.
>
> Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> ---
>  drivers/net/wireless/ath/wil6210/cfg80211.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

The title prefix should be "wil6210:", not "ath:".

-- 
Kalle Valo
