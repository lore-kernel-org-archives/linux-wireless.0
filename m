Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbeGaIog (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:44:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] net/wireless/atmel: fix defined but not used warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <d6ed90e1-c41e-d5b6-c892-ea5e1e6ad7e6@infradead.org>
References: <d6ed90e1-c41e-d5b6-c892-ea5e1e6ad7e6@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Simon Kelley <simon@thekelleys.org.uk>,
        linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-Id: <20180731070545.88C9D6074D@smtp.codeaurora.org> (sfid-20180731_090550_992800_987AA836)
Date: Tue, 31 Jul 2018 07:05:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap <rdunlap@infradead.org> wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix a build warning in drivers/net/wireless/atmel/ when CONFIG_PROC_FS
> is not enabled by marking the unused function as __maybe_unused.
> 
> ../drivers/net/wireless/atmel/atmel.c:1402:12: warning: 'atmel_proc_show' defined but not used [-Wunused-function]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Simon Kelley <simon@thekelleys.org.uk>
> Cc: linux-wireless@vger.kernel.org
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org

I'll drop this as I take Yue's version instead.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10512913/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
