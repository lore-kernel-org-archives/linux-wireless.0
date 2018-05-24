Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37984 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030220AbeEXSrU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 14:47:20 -0400
Received: by mail-wm0-f51.google.com with SMTP id m129-v6so8083722wmb.3
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2018 11:47:19 -0700 (PDT)
Subject: Re: [PATCH 1/3] brcmfmac: allow specifying features per firmware
 version
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20180522131836.26858-1-zajec5@gmail.com>
 <5B051F2A.9090501@broadcom.com>
 <f79ad17d-5d7f-ceac-19e6-2e55d9bb20bf@gmail.com>
 <5B066F28.5070706@broadcom.com> <cacf02df5ce961891e33344ab14a4629@milecki.pl>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B0708B4.5020901@broadcom.com> (sfid-20180524_204827_340289_AF72D457)
Date: Thu, 24 May 2018 20:47:16 +0200
MIME-Version: 1.0
In-Reply-To: <cacf02df5ce961891e33344ab14a4629@milecki.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/24/2018 10:21 AM, Rafał Miłecki wrote:
>
> OT: is your brcmfmac4366c-pcie.bin going to include BCM4366E support?

I would think so. I actually tested with 4366E before passing the 
firmware for verification.

Regards,
Arend
