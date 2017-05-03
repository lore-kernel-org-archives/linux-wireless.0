Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35009 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbdECIFz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 04:05:55 -0400
Received: by mail-oi0-f51.google.com with SMTP id l18so24398295oig.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 01:05:55 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: btcoex: replace init_timer with setup_timer
To: Xie Qirong <cheerx1994@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Piotr Haber <phaber@broadcom.com>
References: <20170503073555.3922-1-cheerx1994@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2f49e699-b9f7-b55f-0afc-7ac03631de28@broadcom.com> (sfid-20170503_100711_465190_8166ADF4)
Date: Wed, 3 May 2017 10:05:52 +0200
MIME-Version: 1.0
In-Reply-To: <20170503073555.3922-1-cheerx1994@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/3/2017 9:35 AM, Xie Qirong wrote:
> Signed-off-by: Xie Qirong <cheerx1994@gmail.com>
> ---
> 
>   setup_timer.cocci suggested the following improvement:
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c:383:1-11: Use
>   setup_timer function for function on line 384.

Move the text above before your sign-off so it will end up in the git 
commit message.

When done you may also add my acknowledgement, ie.:

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend
