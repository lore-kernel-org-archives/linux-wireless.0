Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:43994 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdLAI2a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 03:28:30 -0500
Received: by mail-qt0-f177.google.com with SMTP id w10so12069317qtb.10
        for <linux-wireless@vger.kernel.org>; Fri, 01 Dec 2017 00:28:30 -0800 (PST)
Subject: Re: [PATCH] brcm: add CYW4373 firmwares and Cypress license file
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-firmware@kernel.org
References: <20171201073300.GA13854@aremote07.aus.cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A2112AB.1050307@broadcom.com> (sfid-20171201_092835_468445_CFA1EC62)
Date: Fri, 1 Dec 2017 09:28:27 +0100
MIME-Version: 1.0
In-Reply-To: <20171201073300.GA13854@aremote07.aus.cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/1/2017 8:33 AM, Chi-Hsien Lin wrote:
> Add the CYW4373 SDIO and USB firmware files, alone with the corresponding

'alone' should be 'along'.

> Cypress license file.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chi-hsien Lin<chi-hsien.lin@cypress.com>
> ---
>   LICENCE.cypress            | 139 +++++++++++++++++++++++++++++++++++++++++++++
>   WHENCE                     |   5 ++
>   brcm/brcmfmac4373-sdio.bin | Bin 0 -> 457994 bytes
>   brcm/brcmfmac4373.bin      | Bin 0 -> 479232 bytes
>   4 files changed, 144 insertions(+)
>   create mode 100644 LICENCE.cypress
>   create mode 100644 brcm/brcmfmac4373-sdio.bin
>   create mode 100644 brcm/brcmfmac4373.bin
