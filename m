Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:45501 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbeCIJRz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 04:17:55 -0500
Subject: Re: [PATCH 00/10] staging: wilc1000: fixes for checkpatch issues &
 coding style related
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <add85f12-5e09-d3a9-3d60-1da8cd72b442@microchip.com> (sfid-20180309_101800_387497_085466EF)
Date: Fri, 9 Mar 2018 11:17:51 +0200
MIME-Version: 1.0
In-Reply-To: <1520388839-7048-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

On 07.03.2018 04:13, Ajay Singh wrote:
> This patch series contains modification to remove the checkpatch warnings
> and changes to follow linux coding style.
> 
> Ajay Singh (10):
>   staging: wilc1000: rename pstrHostIFconnectAttr to avoid camelCase
>     issue
>   staging: wilc1000: rename strConnectInfo to avoid camelCase
>   staging: wilc1000: rename label 'ERRORHANDLER' to avoid uppercase name
>   staging: wilc1000: fix line over 80 char in handle_scan()
>   staging: wilc1000: fix line over 80 char in handle_connect()
>   staging: wilc1000: fix line over 80 character in handle_disconnect()
>   staging: wilc1000: rename variables prefix using datatype 'u8'
>   staging: wilc1000: rename WILC_HostIf_PackStaParam to avoid camelCase
>   staging: wilc1000: rename variables using camelCase in
>     handle_rcvd_gnrl_async_info()
>   staging: wilc1000: fix line over 80 char issue in handle_scan_done()
> 
>  drivers/staging/wilc1000/coreconfigurator.c |  28 +-
>  drivers/staging/wilc1000/host_interface.c   | 580 ++++++++++++++--------------
>  2 files changed, 308 insertions(+), 300 deletions(-)
> 
