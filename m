Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50504 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753715AbeDSQWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 12:22:13 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix fw path name for WCN3990 target
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523852805-14292-1-git-send-email-govinds@codeaurora.org>
References: <1523852805-14292-1-git-send-email-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        govinds@codeaurora.org
Message-Id: <20180419162212.BC7B660F6E@smtp.codeaurora.org> (sfid-20180419_182216_667849_69FC1C37)
Date: Thu, 19 Apr 2018 16:22:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> FW path is mapped incorrectly for the WCN3990
> hw version. Fix fw path with correct hw1.0 name.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6da2b2d46ff9 ath10k: fix fw path name for WCN3990 target

-- 
https://patchwork.kernel.org/patch/10342185/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
