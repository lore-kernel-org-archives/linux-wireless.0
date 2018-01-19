Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:52917 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbeASLXI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 06:23:08 -0500
Subject: Re: [PATCH 00/14] fix to remove unnecessary parenthesis,typedef and
 avoid camelCase
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <9fcef768-0db6-892b-98ef-b4bcdb1e10db@microchip.com> (sfid-20180119_122312_119674_42A1920A)
Date: Fri, 19 Jan 2018 13:23:04 +0200
MIME-Version: 1.0
In-Reply-To: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All series Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
with the inline comments.

Ajay, one general remark, please use Capital letters when beginning new
sentences (I'm talking about commit descriptions).

Thanks,
Claudiu Beznea

On 18.01.2018 15:16, Ajay Singh wrote:
> This patch series contains changes to fix issues reported by checkpatch.pl script.
> 
> 
> Ajay Singh (14):
>   staging: wilc1000: remove unnecessary use of parentheses
>   staging: wilc1000: removed unnecessary defined enums typedef
>   staging: wilc1000: fix alignments to match open parenthesis
>   staging: wilc1000: rename host_int_ParseJoinBssParam() and it's
>     variable using camelCase
>   staging: wilc1000: rename camelCase used in Handle_DelAllSta() and its
>     variable
>   staging: wilc1000: rename strWIDList variable to wid_list to avoid
>     camelCase
>   staging: wilc1000: rename u32WidsCount variable to avoid camelCase
>   staging: wilc1000: rename pu8CurrByte variable to avoid camelCase
>   staging: wilc1000: rename pstrHostIFconnectAttr argument to avoid
>     camelCase
>   staging: wilc1000: rename ptstrJoinBssParam variable to avoid
>     camelCase
>   staging: wilc1000: rename strConnectInfo variable to avoid camelCase
>   staging: wilc1000: rename Handle_ScanDone() to avoid camelCase
>   staging: wilc1000: rename Handle_Connect() to avoid camelCase
>   staging: wilc1000: rename Handle_ConnectTimeout() and Handle_Key()
> 
>  drivers/staging/wilc1000/coreconfigurator.c       |   2 +-
>  drivers/staging/wilc1000/host_interface.c         | 936 +++++++++++-----------
>  drivers/staging/wilc1000/linux_wlan.c             |  10 +-
>  drivers/staging/wilc1000/wilc_sdio.c              |   4 +-
>  drivers/staging/wilc1000/wilc_spi.c               |  20 +-
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  64 +-
>  drivers/staging/wilc1000/wilc_wlan.c              |   2 +-
>  drivers/staging/wilc1000/wilc_wlan_cfg.c          |   6 +-
>  drivers/staging/wilc1000/wilc_wlan_if.h           |  72 +-
>  9 files changed, 555 insertions(+), 561 deletions(-)
> 
