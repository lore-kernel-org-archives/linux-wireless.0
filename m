Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58170 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752040AbeC2I4i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:56:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: turn off probe response offloading
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180314122937.14119-1-rfried@codeaurora.org>
References: <20180314122937.14119-1-rfried@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, Ramon Fried <rfried@codeaurora.org>
Message-Id: <20180329085637.9423760C66@smtp.codeaurora.org> (sfid-20180329_105641_439707_CE6C38CF)
Date: Thu, 29 Mar 2018 08:56:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> wrote:

> It appears that the WCN36xx firmware doesn't actually respond to
> probe requests. Until it's resolved, switch the probe response
> responsibility to the 802.11 layer to allow creation of
> hidden SSID AP's.
> 
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ee35eecb0822 wcn36xx: turn off probe response offloading

-- 
https://patchwork.kernel.org/patch/10282035/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
