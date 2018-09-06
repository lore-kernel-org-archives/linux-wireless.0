Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57754 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730304AbeIFUcF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 16:32:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] ath10k: Introduce CE_ATTR_POLL attribute for polling
 pipe
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180828043642.14890-2-govinds@codeaurora.org>
References: <20180828043642.14890-2-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Message-Id: <20180906155557.6BFAC6055B@smtp.codeaurora.org> (sfid-20180906_175600_255209_EEDAC748)
Date: Thu,  6 Sep 2018 15:55:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> Existing copy engine interrupt enable logic assumes that last
> CE is using polling mode and due to this interrupt for last copy engine
> are always disabled. WCN3990 uses last CE for pktlog and
> interrupt remains disabled with existing logic.
> 
> To mitigate this issue, introduce CE_ATTR_POLL flag and control
> the interrupt based on the flag which can be set in ce_attr.
> 
> Testing:
>     Tested on WCN3990 and QCA6174 HW.
>     Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1,
>                WLAN.RM.4.4.1-00109-QCARMSWPZ-1
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

9abcb9371bcc ath10k: introduce CE_ATTR_POLL attribute for polling pipe
713358c321f4 ath10k: enable pktlog for WCN3990 target

-- 
https://patchwork.kernel.org/patch/10577867/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
