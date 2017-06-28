Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59662 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbdF1Ryf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 13:54:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rsi: add in missing RSI_FSM_STATES into array fsm_state
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170622165804.24379-1-colin.king@canonical.com>
References: <20170622165804.24379-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Colin Ian King <colin.king@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20170628175429.3F57760B7F@smtp.codeaurora.org> (sfid-20170628_195459_834115_067E7963)
Date: Wed, 28 Jun 2017 17:54:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Two recent commits added new RSI_FSM_STATES (namely FSM_FW_NOT_LOADED
> and FSM_COMMON_DEV_PARAMS_SENT) and the corresponding table fsm_state
> was not updated to match. This can lead to an array overrun when
> accessing the latter two states in fsm_state. Fix this by adding in
> the missing states.
> 
> Detected by CoverityScan, CID#1398379 ("Illegal address computation")
> 
> Fixes: 9920322ccd8e ("rsi: add tx frame for common device configuration")
> Fixes: 015e367494c1 ("rsi: Register interrupt handler before firmware load")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

58828680af49 rsi: add in missing RSI_FSM_STATES into array fsm_state

-- 
https://patchwork.kernel.org/patch/9804857/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
