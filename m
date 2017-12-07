Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:43047 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdLGKaT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 05:30:19 -0500
Received: by mail-qt0-f195.google.com with SMTP id w10so16197881qtb.10
        for <linux-wireless@vger.kernel.org>; Thu, 07 Dec 2017 02:30:18 -0800 (PST)
Subject: Re: [PATCH] brcmsmac: use ARRAY_SIZE on rfseq_updategainu_events
To: Colin King <colin.king@canonical.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
References: <20171207102047.21635-1-colin.king@canonical.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A291837.1020901@broadcom.com> (sfid-20171207_113556_866906_FB3C901E)
Date: Thu, 7 Dec 2017 11:30:15 +0100
MIME-Version: 1.0
In-Reply-To: <20171207102047.21635-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/7/2017 11:20 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Use the ARRAY_SIZE macro on rfseq_updategainu_events to determine
> size of the array. Improvement suggested by coccinelle.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
