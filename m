Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37099 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752248AbdIEVTD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 17:19:03 -0400
Received: by mail-wm0-f44.google.com with SMTP id u26so24126795wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 14:19:02 -0700 (PDT)
Subject: Re: [PATCH 28/30] brcmfmac: Clean up interrupt macros
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-29-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <22858f29-d0c5-6780-8ccb-ad9f00e1f8dc@broadcom.com> (sfid-20170905_231907_498615_446039FC)
Date: Tue, 5 Sep 2017 23:19:00 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-29-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> Make it more obvious that this code acually enables interrupts, and
> provide nice definitions for the bits in the register.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 3 ++-
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 8 +++++---
>   2 files changed, 7 insertions(+), 4 deletions(-)
