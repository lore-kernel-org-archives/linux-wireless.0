Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60428 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbeG3TXs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 15:23:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v2] ath10k: support for multicast rate control
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1525743291-4306-1-git-send-email-pradeepc@codeaurora.org>
References: <1525743291-4306-1-git-send-email-pradeepc@codeaurora.org>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Message-Id: <20180730174743.DFC386223C@smtp.codeaurora.org> (sfid-20180730_194747_116887_F19F90BC)
Date: Mon, 30 Jul 2018 17:47:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org> wrote:

> Issues a wmi command to firmware when multicast rate change is received with the
> new BSS_CHANGED_MCAST_RATE flag.  Also fixes the incorrect fixed_rate setting
> for CCK rates which got introduced with addition of ath10k_rates_rev2 enum.
> 
> Tested on QCA9984 with firmware ver 10.4-3.6-00104
> 
> Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

cd93b83ad927 ath10k: support for multicast rate control

-- 
https://patchwork.kernel.org/patch/10385043/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
