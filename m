Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36950 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753414AbdIEVVm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 17:21:42 -0400
Received: by mail-wm0-f46.google.com with SMTP id u26so24145838wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 14:21:41 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 27/30] brcmfmac: Replace function index with function
 pointer
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-28-ian@mnementh.co.uk>
Message-ID: <b4bd401a-9241-8381-af24-18440c470cf8@broadcom.com> (sfid-20170905_232145_017146_77C14E5F)
Date: Tue, 5 Sep 2017 23:21:39 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-28-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> In preparation for removing the function array, remove all code that
> refers to function by index and replace with pointers to the function
> itself.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> # Conflicts:
> #	drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 83 ++++++++++++----------
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 15 ++--
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  6 +-
>   3 files changed, 54 insertions(+), 50 deletions(-)
