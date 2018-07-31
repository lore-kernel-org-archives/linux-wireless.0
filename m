Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52202 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbeGaIqV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:46:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] net/wireless/intersil/hostap: fix defined but not
 usedwarnings
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <b2a357a4-dfae-5561-deda-33b2124fc4cf@infradead.org>
References: <b2a357a4-dfae-5561-deda-33b2124fc4cf@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-Id: <20180731070729.7323360708@smtp.codeaurora.org> (sfid-20180731_090732_557534_F909FFB6)
Date: Tue, 31 Jul 2018 07:07:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap <rdunlap@infradead.org> wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build warnings in drivers/net/wireless/intersil/hostap/ when
> CONFIG_PROC_FS is not enabled by marking the unused functions as
> __maybe_unused.
> 
> ../drivers/net/wireless/intersil/hostap/hostap_ap.c:70:12: warning: 'ap_debug_proc_show' defined but not used [-Wunused-function]
> ../drivers/net/wireless/intersil/hostap/hostap_ap.c:994:12: warning: 'prism2_sta_proc_show' defined but not used [-Wunused-function]
> ../drivers/net/wireless/intersil/hostap/hostap_proc.c:16:12: warning: 'prism2_debug_proc_show' defined but not used [-Wunused-function]
> ../drivers/net/wireless/intersil/hostap/hostap_proc.c:49:12: warning: 'prism2_stats_proc_show' defined but not used [-Wunused-function]
> ../drivers/net/wireless/intersil/hostap/hostap_proc.c:177:12: warning: 'prism2_crypt_proc_show' defined but not used [-Wunused-function]
> ../drivers/net/wireless/intersil/hostap/hostap_hw.c:2901:12: warning: 'prism2_registers_proc_show' defined but not used [-Wunused-function]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jouni Malinen <j@w1.fi>
> Cc: linux-wireless@vger.kernel.org
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org

I'll drop this as I take Yue's patch.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10512915/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
