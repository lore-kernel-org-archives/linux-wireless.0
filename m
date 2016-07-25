Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:35603 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbcGYUgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 16:36:37 -0400
Received: by mail-yw0-f182.google.com with SMTP id j12so157706856ywb.2
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 13:36:37 -0700 (PDT)
MIME-Version: 1.0
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 25 Jul 2016 17:36:35 -0300
Message-ID: <CAOMZO5Dto7bScKrz9tmM5TDg8Tss5xGiO77F4u==V4pLgXZZGw@mail.gmail.com> (sfid-20160725_223641_261513_4F7CBF04)
Subject: BRCM4339 NVRAM file
To: frankyl@broadcom.com, Arend van Spriel <arend@broadcom.com>,
	pieterpg@broadcom.com, John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to use brcm4339 on a imx6ul-pico board running kernel 4.7.

According to commit bed89b64bcbc7 (" brcmfmac: add firmware and nvram
file name for bcm4339") we need to provide brcmfmac4339-sdio.bin and
brcmfmac4339-sdio.txt files.

Was able to get the brcmfmac4339-sdio.bin from linux-firmware git
tree, but could not find the nvram file: brcmfmac4339-sdio.txt.

Does anyone know where brcmfmac4339-sdio.txt can be found?

Thanks,

Fabio Estevam
