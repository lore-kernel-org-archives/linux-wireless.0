Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:43276 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbeCPKRb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:17:31 -0400
Received: by mail-io0-f196.google.com with SMTP id l12so12023382ioc.10
        for <linux-wireless@vger.kernel.org>; Fri, 16 Mar 2018 03:17:30 -0700 (PDT)
Subject: Re: [PATCH 6/6] Update license for brcm firmware
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-firmware@vger.kernel.org
References: <1521194806-71801-1-git-send-email-chi-hsien.lin@cypress.com>
 <1521194806-71801-7-git-send-email-chi-hsien.lin@cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AAB99B6.3080803@broadcom.com> (sfid-20180316_111738_326152_AB5860FF)
Date: Fri, 16 Mar 2018 11:17:26 +0100
MIME-Version: 1.0
In-Reply-To: <1521194806-71801-7-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/16/2018 11:06 AM, Chi-Hsien Lin wrote:
> Upload a Cypress version of below firmware and hence update the
> license:
>
> brcm/brcmfmac43340-sdio.bin
> brcm/brcmfmac43362-sdio.bin
> brcm/brcmfmac43430-sdio.bin
> brcm/brcmfmac4354-sdio.bin
> brcm/brcmfmac4356-pcie.bin

Hi Chi-Hsien,

It would be better to update the WHENCE file in the commit adding the 
binary. That way the repository contents are always correct from commit 
to commit.

Regards,
Arend

> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>   WHENCE | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/WHENCE b/WHENCE
> index 2fb6048..e9ca599 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -2226,9 +2226,7 @@ File: brcm/brcmfmac43236b.bin
>   File: brcm/brcmfmac4329-sdio.bin
>   File: brcm/brcmfmac4330-sdio.bin
>   File: brcm/brcmfmac4334-sdio.bin
> -File: brcm/brcmfmac43340-sdio.bin
>   File: brcm/brcmfmac4335-sdio.bin
> -File: brcm/brcmfmac43362-sdio.bin
>   File: brcm/brcmfmac4339-sdio.bin
>   File: brcm/brcmfmac43241b0-sdio.bin
>   File: brcm/brcmfmac43241b4-sdio.bin
> @@ -2236,13 +2234,10 @@ File: brcm/brcmfmac43241b5-sdio.bin
>   File: brcm/brcmfmac43242a.bin
>   File: brcm/brcmfmac43143.bin
>   File: brcm/brcmfmac43143-sdio.bin
> -File: brcm/brcmfmac43430-sdio.bin
>   File: brcm/brcmfmac43430a0-sdio.bin
>   File: brcm/brcmfmac43455-sdio.bin
>   File: brcm/brcmfmac4350c2-pcie.bin
>   File: brcm/brcmfmac4350-pcie.bin
> -File: brcm/brcmfmac4354-sdio.bin
> -File: brcm/brcmfmac4356-pcie.bin
>   File: brcm/brcmfmac4356-sdio.bin
>   File: brcm/brcmfmac43569.bin
>   File: brcm/brcmfmac43570-pcie.bin
> @@ -2254,6 +2249,11 @@ File: brcm/brcmfmac4371-pcie.bin
>
>   Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
>
> +File: brcm/brcmfmac43340-sdio.bin
> +File: brcm/brcmfmac43362-sdio.bin
> +File: brcm/brcmfmac43430-sdio.bin
> +File: brcm/brcmfmac4354-sdio.bin
> +File: brcm/brcmfmac4356-pcie.bin
>   File: brcm/brcmfmac4373-sdio.bin
>   File: brcm/brcmfmac4373.bin
>
>
