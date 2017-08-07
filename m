Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:37254 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753159AbdHGLZt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:25:49 -0400
Received: by mail-wr0-f173.google.com with SMTP id 33so585628wrz.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:25:48 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 05/34] brcmfmac: Remove dead IO code
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-6-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E3B.3010203@broadcom.com> (sfid-20170807_132551_999547_3996AE57)
Date: Mon, 7 Aug 2017 13:25:47 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-6-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-07-17 22:25, Ian Molton wrote:
> 	The value passed to brcmf_sdiod_addrprep() is *always* 4
> remove this parameter and the unused code to handle it.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
