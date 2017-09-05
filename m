Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37744 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752872AbdIEVU6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 17:20:58 -0400
Received: by mail-wm0-f49.google.com with SMTP id u26so24140895wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 14:20:57 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 22/30] brcmfmac: Rename buscore->core for consistency
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-23-ian@mnementh.co.uk>
Message-ID: <66c07456-f1cc-51ed-c01a-1ff045fd07f9@broadcom.com> (sfid-20170905_232110_148502_73B6534D)
Date: Tue, 5 Sep 2017 23:20:55 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-23-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> Avoid confusion with unrelated _buscore labels.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
