Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751856AbeFFM1r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jun 2018 08:27:47 -0400
Received: from mail-qt0-f181.google.com (mail-qt0-f181.google.com [209.85.216.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80F7720870
        for <linux-wireless@vger.kernel.org>; Wed,  6 Jun 2018 12:27:46 +0000 (UTC)
Received: by mail-qt0-f181.google.com with SMTP id i18-v6so6055141qtp.12
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2018 05:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <1527663267-71412-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1527663267-71412-1-git-send-email-chi-hsien.lin@cypress.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Wed, 6 Jun 2018 08:27:34 -0400
Message-ID: <CA+5PVA65=65m+xFnXPEXWx4_xVjv-cMGStvx07=yo7B_ZdN_TA@mail.gmail.com> (sfid-20180606_142752_161078_3F901EA6)
Subject: Re: [PATCH V4 0/6] Cypress license and firmware update
To: chi-hsien.lin@cypress.com
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        wright.feng@cypress.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 30, 2018 at 3:27 AM Chi-Hsien Lin <chi-hsien.lin@cypress.com> wrote:
>
> Update Cypress license termination clause and several firmware files.
>
> Chi-Hsien Lin (6):
>   Update Cypress license termination clause
>   brcm: update firmware for bcm43430 sdio
>   brcm: update firmware for bcm43340 sdio
>   brcm: update firmware for bcm43362 sdio
>   brcm: update firmware for bcm4354 sdio
>   brcm: update firmware for bcm4356 pcie
>
>  LICENCE.cypress             |   5 ++---
>  WHENCE                      |  10 +++++-----
>  brcm/brcmfmac43340-sdio.bin | Bin 402210 -> 400864 bytes
>  brcm/brcmfmac43362-sdio.bin | Bin 219557 -> 200801 bytes
>  brcm/brcmfmac43430-sdio.bin | Bin 369577 -> 388739 bytes
>  brcm/brcmfmac4354-sdio.bin  | Bin 626589 -> 605388 bytes
>  brcm/brcmfmac4356-pcie.bin  | Bin 661999 -> 648770 bytes
>  7 files changed, 7 insertions(+), 8 deletions(-)

I've applied the series and pushed it out.  Thank you!

josh
