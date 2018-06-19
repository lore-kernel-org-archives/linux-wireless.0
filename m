Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35237 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030305AbeFSTdm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 15:33:42 -0400
Received: by mail-wm0-f68.google.com with SMTP id j15-v6so2573003wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 12:33:41 -0700 (PDT)
Subject: Re: [PATCH V3 1/2] brcmfmac: detect firmware support for monitor
 interface
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180619154809.25698-1-zajec5@gmail.com>
 <20180619154809.25698-2-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B295A93.10801@broadcom.com> (sfid-20180619_213346_218353_A2B70233)
Date: Tue, 19 Jun 2018 21:33:39 +0200
MIME-Version: 1.0
In-Reply-To: <20180619154809.25698-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/19/2018 5:48 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> Most of firmwares support creating monitor interface. The newest ones
> explicitly /announce/ it using a "monitor" entry in the list of
> capabilities.
>
> Check (and store) internally info about monitor mode support using a
> new feature flag. Once we sort out all details of handling monitor
> interface it will be used when reporting available interfaces to the
> cfg80211.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V3: Patch added to the series
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 26 ++++++++++++++++++++++
>   .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  4 +++-
>   .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |  2 ++
>   3 files changed, 31 insertions(+), 1 deletion(-)
