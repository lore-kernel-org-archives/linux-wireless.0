Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59178 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbeG3TWC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 15:22:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath10k: fix open brace location
 inath10k_wmi_tlv_op_gen_dbglog_cfg()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <153069556911.18112.15554530524319470412.stgit@potku.adurom.net>
References: <153069556911.18112.15554530524319470412.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180730174557.86F9062246@smtp.codeaurora.org> (sfid-20180730_194601_317673_444F1DAC)
Date: Mon, 30 Jul 2018 17:45:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> wrote:

> Fixes a recently added checkpatch warning:
> 
> wmi-tlv.c:2703: open brace '{' following function definitions go on the next line
> 
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

1e3c43a7f111 ath10k: fix open brace location in ath10k_wmi_tlv_op_gen_dbglog_cfg()

-- 
https://patchwork.kernel.org/patch/10506253/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
