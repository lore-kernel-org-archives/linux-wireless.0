Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751631AbdKYP3g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 10:29:36 -0500
Received: from mail-qk0-f176.google.com (mail-qk0-f176.google.com [209.85.220.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4032D218A3
        for <linux-wireless@vger.kernel.org>; Sat, 25 Nov 2017 15:29:35 +0000 (UTC)
Received: by mail-qk0-f176.google.com with SMTP id a142so27648736qkb.5
        for <linux-wireless@vger.kernel.org>; Sat, 25 Nov 2017 07:29:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1511467106-21175-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1511467106-21175-1-git-send-email-arend.vanspriel@broadcom.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Sat, 25 Nov 2017 10:29:33 -0500
Message-ID: <CA+5PVA5e2xEdGVZi4Nqu-GgrbvyKH0+cChaBBwutyd+cBKrp8w@mail.gmail.com> (sfid-20171125_163009_193362_03A7BDD6)
Subject: Re: [PATCH 0/5] brcm: firmware addressing security issues
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-firmware@kernel.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 23, 2017 at 2:58 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> This series of firmware patches address a number of security
> issues as listed in the individual commit messages. It also
> adds new firmware for bcm43430 rev 0.
>
> The series applies to the master branch of the linux-firmware
> repository.
>
> Arend van Spriel (5):
>   brcm: update firmware for bcm4339
>   brcm: introduce firmware for bcm43430 revision 0
>   brcm: update firmware for bcm4354
>   brcm: update firmware for bcm4356
>   brcm: update firmware for bcm4358
>
>  WHENCE                        |   1 +
>  brcm/brcmfmac4339-sdio.bin    | Bin 493599 -> 562183 bytes
>  brcm/brcmfmac43430a0-sdio.bin | Bin 0 -> 382455 bytes
>  brcm/brcmfmac4354-sdio.bin    | Bin 591837 -> 626589 bytes
>  brcm/brcmfmac4356-pcie.bin    | Bin 623012 -> 661999 bytes
>  brcm/brcmfmac4358-pcie.bin    | Bin 629040 -> 633817 bytes
>  6 files changed, 1 insertion(+)
>  create mode 100644 brcm/brcmfmac43430a0-sdio.bin

Series applied.  Thanks!

josh
