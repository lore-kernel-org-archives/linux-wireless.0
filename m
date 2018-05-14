Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:47043 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751853AbeENIPy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 04:15:54 -0400
Received: by mail-qt0-f180.google.com with SMTP id m16-v6so14955334qtg.13
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 01:15:54 -0700 (PDT)
Subject: Re: brcmfmac: Updating Broadcom/Cypress Wifi/BT firmware
To: Stefan Wahren <stefan.wahren@i2se.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>
References: <1350822038.83583.1525284334972@email.1und1.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kevin Hilman <khilman@baylibre.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AF945B8.3070801@broadcom.com> (sfid-20180514_101603_304261_6B0BEE3F)
Date: Mon, 14 May 2018 10:15:52 +0200
MIME-Version: 1.0
In-Reply-To: <1350822038.83583.1525284334972@email.1und1.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/2/2018 8:05 PM, Stefan Wahren wrote:
> Hi,
> i wanted to know, if there are any plans to update the Broadcom/Cypress firmware under:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>
> As BCM2835 maintainer i'm interested in the following files:
>
> brcm/brcmfmac43430-sdio.bin
> brcm/brcmfmac43455-sdio.bin

To my knowledge (just checked ;-) ) these are already in the repository.

> brcm/brcmfmac43430-sdio.txt

We do not distribute these .txt files aka nvram files as they are board 
specific and no good solution to express that in the filename.

> brcm/BCM43430A1.hcd

The BT side is not handled by us. Might be different within Cypress though.

Regards,
Arend
