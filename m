Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:32799 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbbHSQiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 12:38:52 -0400
Received: by iods203 with SMTP id s203so15564263iod.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 09:38:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439708139-7527-2-git-send-email-arend@broadcom.com>
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>
	<1439708139-7527-2-git-send-email-arend@broadcom.com>
Date: Wed, 19 Aug 2015 18:38:51 +0200
Message-ID: <CACna6rwGPgHKKKcP+SznWf=hDb+jLPnKvk+PjZbF9kxvsVDX_w@mail.gmail.com> (sfid-20150819_183855_808541_5660F3D3)
Subject: Re: [PATCH V2 1/7] brcmfmac: Add support for host platform NVRAM loading.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
>
> Host platforms such as routers supported by OpenWRT can
> support NVRAM reading directly from internal NVRAM store.
> With this patch the nvram load routines will fall back to
> this method when there is no nvram file and support is
> available in the kernel.
>
> Cc: Rafał Miłecki <zajec5@gmail.com>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> V2:
> - addressed comments from Rafał.

Well, you dropped unneeded change to the brcmf_nvram_handle_value
function, but you ignored the rest of my comments. Take a look at them
again please:
https://patchwork.kernel.org/patch/6767961/
