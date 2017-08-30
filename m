Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35481 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdH3Svw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 14:51:52 -0400
Received: by mail-wm0-f53.google.com with SMTP id a80so15539694wma.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 11:51:51 -0700 (PDT)
Subject: Re: [PATCH 01/30] brcmfmac: Fix parameter order in
 brcmf_sdiod_f0_writeb()
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-2-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4a840cca-d07a-15a7-7d31-b8269bb9feb3@broadcom.com> (sfid-20170830_205155_155203_C59509B3)
Date: Wed, 30 Aug 2017 20:51:49 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-2-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 22-08-17 13:25, Ian Molton wrote:
> 	All the other IO functions are the other way round in this
> driver. Make this one match.

Sorry for being a nit, but not sure why the commit message starts with a 
tab.

Other than that...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
