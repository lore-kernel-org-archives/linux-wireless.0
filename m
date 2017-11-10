Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40562 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755575AbdKJCaL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 21:30:11 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,1/7] brcmfmac: handle FWHALT mailbox indication
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1510148197-17851-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1510148197-17851-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20171110023011.0026A607E5@smtp.codeaurora.org> (sfid-20171110_033015_438263_450EFED8)
Date: Fri, 10 Nov 2017 02:30:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: Arend Van Spriel <arend.vanspriel@broadcom.com>
> 
> The firmware uses a mailbox to communicate to the host what is going
> on. In the driver we validate the bit received. Various people seen
> the following message:
> 
>  brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
> 
> Bit 4 is cause of this message, but this actually indicates the firmware
> has halted. Handle this bit by giving a more meaningful error message.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

7 patches applied to wireless-drivers-next.git, thanks.

2fd3877b5bb7 brcmfmac: handle FWHALT mailbox indication
6c219b008815 brcmfmac: disable packet filtering in promiscuous mode
8c6efda22f5f brcmfmac: cleanup brcmf_cfg80211_escan() function
df2d8388bc96 brcmfmac: use msecs_to_jiffies() instead of calculation using HZ
588378f15cff brcmfmac: get rid of brcmf_cfg80211_escan() function
bbf35414cd23 brcmfmac: get rid of struct brcmf_cfg80211_info::active_scan field
bd99a3013bdc brcmfmac: move configuration of probe request IEs

-- 
https://patchwork.kernel.org/patch/10048525/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
