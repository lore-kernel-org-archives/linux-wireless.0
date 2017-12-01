Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35432 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdLAT5L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 14:57:11 -0500
Received: by mail-wm0-f68.google.com with SMTP id f9so5301571wmh.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Dec 2017 11:57:11 -0800 (PST)
Subject: Re: [PATCH V2] brcm: add CYW4373 firmwares and Cypress license file
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com
References: <20171201084243.GA58942@aremote07.aus.cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f96ddf93-0e1d-d6f1-570b-fd3c8ec711e0@broadcom.com> (sfid-20171201_205724_285727_AFFEDE30)
Date: Fri, 1 Dec 2017 20:57:09 +0100
MIME-Version: 1.0
In-Reply-To: <20171201084243.GA58942@aremote07.aus.cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01-12-17 09:43, Chi-Hsien Lin wrote:
> Add the CYW4373 SDIO and USB firmware files, along with the corresponding
> Cypress license file.

Just wanted to be sure. These firmware files contain a CLM to get the 
device operational, ie. no separate CLM download is needed.

Regards,
Arend

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
