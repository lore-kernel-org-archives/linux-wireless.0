Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:42853 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932434AbeE2JZy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 05:25:54 -0400
Received: by mail-qk0-f194.google.com with SMTP id j80-v6so9197230qke.9
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2018 02:25:54 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: stop watchdog before detach and free everything
To: Michael Trimarchi <michael@amarulasolutions.com>
References: <1527493857-2220-1-git-send-email-michael@amarulasolutions.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B0D1C9E.4000800@broadcom.com> (sfid-20180529_112612_299592_841152FA)
Date: Tue, 29 May 2018 11:25:50 +0200
MIME-Version: 1.0
In-Reply-To: <1527493857-2220-1-git-send-email-michael@amarulasolutions.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/28/2018 9:50 AM, Michael Trimarchi wrote:
> Watchdog need to be stopped in brcmf_sdio_remove to avoid
> i
> The system is going down NOW!
> [ 1348.110759] Unable to handle kernel NULL pointer dereference at virtual address 000002f8
> Sent SIGTERM to all processes

[snip]

Please send a V2 with your configuration details to the commit message, 
ie. using built-in driver, no firmware in place, etc.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 7 +++++++
>   1 file changed, 7 insertions(+)
