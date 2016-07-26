Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35814 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbcGZTUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2016 15:20:30 -0400
Received: by mail-wm0-f53.google.com with SMTP id f65so186064887wmi.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2016 12:20:30 -0700 (PDT)
Subject: Re: BRCM4339 NVRAM file
To: Fabio Estevam <festevam@gmail.com>, frankyl@broadcom.com,
	Arend van Spriel <arend@broadcom.com>, pieterpg@broadcom.com,
	John Linville <linville@tuxdriver.com>
References: <CAOMZO5Dto7bScKrz9tmM5TDg8Tss5xGiO77F4u==V4pLgXZZGw@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5797B7FB.4090707@broadcom.com> (sfid-20160726_212035_116978_16CCB2CE)
Date: Tue, 26 Jul 2016 21:20:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAOMZO5Dto7bScKrz9tmM5TDg8Tss5xGiO77F4u==V4pLgXZZGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 25-07-16 22:36, Fabio Estevam wrote:
> Hi,
> 
> I am trying to use brcm4339 on a imx6ul-pico board running kernel 4.7.
> 
> According to commit bed89b64bcbc7 (" brcmfmac: add firmware and nvram
> file name for bcm4339") we need to provide brcmfmac4339-sdio.bin and
> brcmfmac4339-sdio.txt files.
> 
> Was able to get the brcmfmac4339-sdio.bin from linux-firmware git
> tree, but could not find the nvram file: brcmfmac4339-sdio.txt.
> 
> Does anyone know where brcmfmac4339-sdio.txt can be found?

I though it would be mentioned in [1], but unfortunately not (will
change that). The nvram is board specific so you will have to ask the
vendor supplying the bcm4339. From what I googled that would be
TechNexion, right?

Regards,
Arend

[1] https://wireless.wiki.kernel.org/en/users/drivers/brcm80211

> Thanks,
> 
> Fabio Estevam
> 
