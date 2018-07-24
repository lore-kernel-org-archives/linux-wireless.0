Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:39765 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388390AbeGXJJz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 05:09:55 -0400
Subject: Re: [PATCH 0/4] staging: wilc1000: make use of descriptor-based
 interface for GPIO
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linus.walleij@linaro.org>
References: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <5ee85fef-e900-b808-1c22-6eca13a54f81@microchip.com> (sfid-20180724_100444_518768_D6232A4C)
Date: Tue, 24 Jul 2018 11:04:20 +0300
MIME-Version: 1.0
In-Reply-To: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

On 20.07.2018 15:01, Ajay Singh wrote:
> This patch series contains changes mainly related to make use of
> descriptor-based interface instead of integer-based interface for GPIO.
> Modified the compatible string to use 'microchip' instead of 'atmel' prefix.
> Also added the DT binding reference file.
> 
> This patch is created on top of [1] patch series.
> 
> [1]. https://www.spinics.net/lists/linux-wireless/msg175360.html
> 
> Ajay Singh (4):
>   staging: wilc1000: remove gpio parameter from wilc_netdev_init()
>   staging: wilc1000: rename variable from 'gpio' to 'gpio_irq'
>   staging: wilc1000: change compatible string from atmel to microchip
>   staging: wilc1000: use descriptor-based interface for GPIO
> 
>  drivers/staging/wilc1000/TODO                      |  4 ---
>  drivers/staging/wilc1000/linux_wlan.c              | 42 +++++++++-------------
>  .../staging/wilc1000/microchip,wilc1000,sdio.txt   | 32 +++++++++++++++++
>  .../staging/wilc1000/microchip,wilc1000,spi.txt    | 26 ++++++++++++++
>  drivers/staging/wilc1000/wilc_sdio.c               | 38 ++++++++++++++------
>  drivers/staging/wilc1000/wilc_spi.c                | 40 +++++++++++++--------
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h      |  5 +--
>  7 files changed, 130 insertions(+), 57 deletions(-)
>  create mode 100644 drivers/staging/wilc1000/microchip,wilc1000,sdio.txt
>  create mode 100644 drivers/staging/wilc1000/microchip,wilc1000,spi.txt
> 
