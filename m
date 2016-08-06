Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:35513 "EHLO
	mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbcHFUgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2016 16:36:25 -0400
Received: by mail-ua0-f170.google.com with SMTP id i31so75110317uai.2
        for <linux-wireless@vger.kernel.org>; Sat, 06 Aug 2016 13:36:24 -0700 (PDT)
MIME-Version: 1.0
From: Fabio Estevam <festevam@gmail.com>
Date: Sat, 6 Aug 2016 12:15:10 -0300
Message-ID: <CAOMZO5BVB4YTsdzhU2f7jKZop6i1QaGGT2YM3Yw3DbYxeJ-v5w@mail.gmail.com> (sfid-20160806_223629_164263_165F36F9)
Subject: brcmfmac43430-sdio.bin in linux-firmware
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I managed to get Wifi working on a imx7 warp board, which has a BCM43430 device.

I used the firmware from the RaspberryPi repository:
https://github.com/RPi-Distro/firmware-nonfree/tree/master/brcm80211/brcm

Are there any plans to make brcmfmac43430-sdio.bin available in the
official linux-firmware repository?

Thanks,

Fabio Estevam
