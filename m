Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:50122 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751365AbdITTdS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 15:33:18 -0400
Received: by mail-qt0-f173.google.com with SMTP id o3so2860229qte.6
        for <linux-wireless@vger.kernel.org>; Wed, 20 Sep 2017 12:33:18 -0700 (PDT)
MIME-Version: 1.0
From: Vanessa Ayumi Maegima <van.ayumi@gmail.com>
Date: Wed, 20 Sep 2017 16:33:17 -0300
Message-ID: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com> (sfid-20170920_213321_932995_459D66D2)
Subject: AP6335 with mainline kernel
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, embed3d@gmail.com,
        joerg.krause@embedded.rocks,
        Vanessa Maegima <vanessa.maegima@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to enable Wifi on imx7d-pico using mainline kernel. imx7d-pico
has an AP6335 chip.

I am facing some issues related to the nvram file. I am using the firmware
provided by Buildroot (brcmfmac4339-sdio.bin). I get the following error:

[    8.630380] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000):
clkctl 0x50

I have tried to use the firmware and nvram provided by TechNexion but I get
the same error.

Is there anyone that could enable Wifi on AP6335 using kernel mainline?
What nvram file was used?

I am able to use Wifi on the board if I use the firmware, nvram file and kernel
provided by TechNexion. They use a 4.1 kernel from NXP with the bcmdhd
driver.

So I know that the hardware is functional.

Any suggestions as how to get it working with a 4.13 and brcmfmac driver is
appreciated.

Thanks!

Regards,
Vanessa
