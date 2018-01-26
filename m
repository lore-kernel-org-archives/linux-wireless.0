Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40440 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbeAZGFa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 01:05:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: correct the length of DRAM dump for QCA6174 hw3.x/QCA9377
 hw1.1
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1516945221-4710-2-git-send-email-yyuwang@codeaurora.org>
References: <1516945221-4710-2-git-send-email-yyuwang@codeaurora.org>
To: Yu Wang <yyuwang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180126060530.255046050D@smtp.codeaurora.org> (sfid-20180126_070538_500923_A614966F)
Date: Fri, 26 Jan 2018 06:05:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yu Wang <yyuwang@codeaurora.org> wrote:

> The length of DRAM dump for QCA6174 hw3.0/hw3.2 and QCA9377 hw1.1
> are less than the actual value, some coredump contents are missed.
> To fix it, change the length from 0x90000 to 0xa8000.
> 
> Fixes: 703f261dd77f ("ath10k: add memory dump support for QCA6174/QCA9377")
> Signed-off-by: Yu Wang <yyuwang@codeaurora.org>

I'm planning to queue this to 4.16.

-- 
https://patchwork.kernel.org/patch/10185101/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
