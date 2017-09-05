Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33883 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752920AbdIEVVE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 17:21:04 -0400
Received: by mail-wm0-f54.google.com with SMTP id 137so24505482wmj.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 14:21:04 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 23/30] brcmfmac: stabilise the value of ->sbwad in use for
 some xfer routines.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-24-ian@mnementh.co.uk>
Message-ID: <d2a7c558-c101-ff7e-bd38-2903259943b9@broadcom.com> (sfid-20170905_232110_527853_7AD797CC)
Date: Tue, 5 Sep 2017 23:21:02 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-24-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> The IO functions operate within the Chipcommon IO window. Explicitly
> set this, rather than relying on the last initialisation IO access to
> leave it set to the right value by chance.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 ++++----
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 5 +++++
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 1 +
>   3 files changed, 10 insertions(+), 4 deletions(-)
