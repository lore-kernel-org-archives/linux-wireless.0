Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38357 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753209AbdHGLyu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:54:50 -0400
Received: by mail-wm0-f52.google.com with SMTP id m85so5106115wma.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:54:50 -0700 (PDT)
Subject: Re: [PATCH 15/34] brcmfamc: remove unnecessary call to
 brcmf_sdiod_set_backplane_window()
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-16-ian@mnementh.co.uk> <59884AFC.8090508@broadcom.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59885508.8050805@broadcom.com> (sfid-20170807_135454_956720_D1A91539)
Date: Mon, 7 Aug 2017 13:54:48 +0200
MIME-Version: 1.0
In-Reply-To: <59884AFC.8090508@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/7/2017 1:11 PM, Arend van Spriel wrote:
> On 7/26/2017 10:25 PM, Ian Molton wrote:
>> All functions that might require the window address changing call
>> brcmf_sdiod_set_backplane_window() prior to access. Thus resetting
>> the window is not required.

Actually noticed a minor nit. The subject says "brcmfamc".

Regards,
Arend

> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 5 -----
>>   1 file changed, 5 deletions(-)
>
