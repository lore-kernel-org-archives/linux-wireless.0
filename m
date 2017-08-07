Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36870 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbdHGM1g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 08:27:36 -0400
Received: by mail-wm0-f48.google.com with SMTP id t201so5827400wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 05:27:35 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] brcmfmac: Add support for CYW4373 SDIO/USB chipset
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
References: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
 <1501753079-1758-2-git-send-email-wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59885CB5.2040007@broadcom.com> (sfid-20170807_142739_855011_40307725)
Date: Mon, 7 Aug 2017 14:27:33 +0200
MIME-Version: 1.0
In-Reply-To: <1501753079-1758-2-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/3/2017 11:37 AM, Wright Feng wrote:
> From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>
> Add support for CYW4373 SDIO/USB chipset.
> CYW4373 is a 1x1 dual-band 11ac chipset with 20/40/80Mhz channel support.
> It's a WiFi/BT combo device.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
> v2: add new chip(4737) info in commit message

comment below...

> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c     | 1 +
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 2 ++
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c       | 4 +++-
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c        | 9 ++++++++-
>   drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 3 +++
>   include/linux/mmc/sdio_ids.h                                  | 1 +
>   6 files changed, 18 insertions(+), 2 deletions(-)
>

[...]

> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index b733eb4..abacd54 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -39,6 +39,7 @@
>   #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
>   #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
>   #define SDIO_DEVICE_ID_BROADCOM_4356		0x4356
> +#define SDIO_DEVICE_ID_CYPRESS_4373		0x4373

So is there no specific Cypress SDIO vendor ID?

>   #define SDIO_VENDOR_ID_INTEL			0x0089
>   #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
>
