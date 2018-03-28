Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753533AbeC1PVQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 11:21:16 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [07/12] ath10k: Add MSA handshake QMI mgs support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522042832-25975-1-git-send-email-govinds@codeaurora.org>
References: <1522042832-25975-1-git-send-email-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, bjorn.andersson@linaro.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Message-Id: <20180328152116.7888B60AFB@smtp.codeaurora.org> (sfid-20180328_172120_409603_88B5D640)
Date: Wed, 28 Mar 2018 15:21:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> HOST allocates 2mb of region for modem and WCN3990
> secure access and provides the address and access
> control to target for secure access.
> Add MSA handshake request/response messages.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This added a new ath10k-check warning:

drivers/net/wireless/ath/ath10k/qmi.c:433: void function return statements are not generally useful

-- 
https://patchwork.kernel.org/patch/10307183/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
