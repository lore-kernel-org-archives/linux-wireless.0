Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:19012 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbbHSU4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 16:56:03 -0400
Message-ID: <55D4ED5E.8080504@broadcom.com> (sfid-20150819_225609_826991_728F38D3)
Date: Wed, 19 Aug 2015 22:55:58 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH V2 1/7] brcmfmac: Add support for host platform NVRAM
 loading.
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>	<1439708139-7527-2-git-send-email-arend@broadcom.com> <CACna6rwGPgHKKKcP+SznWf=hDb+jLPnKvk+PjZbF9kxvsVDX_w@mail.gmail.com>
In-Reply-To: <CACna6rwGPgHKKKcP+SznWf=hDb+jLPnKvk+PjZbF9kxvsVDX_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/19/2015 06:38 PM, Rafał Miłecki wrote:
> On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> Host platforms such as routers supported by OpenWRT can
>> support NVRAM reading directly from internal NVRAM store.
>> With this patch the nvram load routines will fall back to
>> this method when there is no nvram file and support is
>> available in the kernel.
>>
>> Cc: Rafał Miłecki <zajec5@gmail.com>
>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>> V2:
>> - addressed comments from Rafał.
>
> Well, you dropped unneeded change to the brcmf_nvram_handle_value
> function, but you ignored the rest of my comments. Take a look at them
> again please:
> https://patchwork.kernel.org/patch/6767961/

Kalle,

Can you remove this patch from the series and apply the rest. Just 
verified over here the remaining patches apply cleanly on 
wireless-drivers-next.

Regards,
Arend
