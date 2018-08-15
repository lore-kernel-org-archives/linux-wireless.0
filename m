Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:42349 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbeHOMGX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 08:06:23 -0400
Received: by mail-qk0-f194.google.com with SMTP id 13-v6so310876qkl.9
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2018 02:15:02 -0700 (PDT)
Subject: Re: [PATCH] Add CYW89342 mini-PCIe device
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org
References: <1534323982-49462-1-git-send-email-chi-hsien.lin@cypress.com>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jia-Shyr Chuang <saint.chuang@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B73EF13.9000207@broadcom.com> (sfid-20180815_111708_021178_49ED9038)
Date: Wed, 15 Aug 2018 11:14:59 +0200
MIME-Version: 1.0
In-Reply-To: <1534323982-49462-1-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/15/2018 11:06 AM, Chi-Hsien Lin wrote:
> From: Jia-Shyr Chuang <saint.chuang@cypress.com>
>
> CYW89342 is a 2x2 MIMO, 802.11a/b/g/n/ac, SDIO 3.0 and PCIe 3.0 for
> WLAN. It is a member of 4355/4359 family.

So the device support SDIO, but this patch only adds the PCIe variant. 
The subject mentions that already, but mentioning SDIO in the commit 
message may confuse people. I would just drop the host interface 
references, ie. SDIO and PCIe from the commit message.

Regards,
Arend

> Signed-off-by: Jia-Shyr Chuang <saint.chuang@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 1 +
>   1 file changed, 1 insertion(+)
