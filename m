Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:2109 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbeDYHkm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 03:40:42 -0400
Subject: Re: [PATCH 0/2] staging: wilc1000: TODO list updates
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1524589623-1534-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <f9c18980-13cf-f4f6-8004-492749c1f7ef@microchip.com> (sfid-20180425_094045_813256_230AFB26)
Date: Wed, 25 Apr 2018 09:40:38 +0200
MIME-Version: 1.0
In-Reply-To: <1524589623-1534-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

On 24.04.2018 19:07, Ajay Singh wrote:
> Updated the TODO list by removing items, which are already addressed.
> Also remove the code to handle IOCTL(SIOCSIWPRIV) as Wext support is
> not present in the driver.
> 
> Ajay Singh (2):
>   staging: wilc1000: remove registering of ndo_do_ioctl callback
>   staging: wilc1000: updated TODO list
> 
>  drivers/staging/wilc1000/TODO         |  8 -----
>  drivers/staging/wilc1000/linux_wlan.c | 63 -----------------------------------
>  2 files changed, 71 deletions(-)
> 
