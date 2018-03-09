Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:45508 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbeCII1p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 03:27:45 -0500
Subject: Re: [PATCH 00/10] staging: wilc1000: fixes related to camelCase &
 line over 80 chars
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <12c693ce-e096-5462-0d7f-859867f76379@microchip.com> (sfid-20180309_092748_477379_1BF8C181)
Date: Fri, 9 Mar 2018 10:27:40 +0200
MIME-Version: 1.0
In-Reply-To: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

On 07.03.2018 03:32, Ajay Singh wrote:
> Patch series contains fixes to remove checkpatch reported warnings.
> 
> Ajay Singh (10):
>   staging: wilc1000: rename strHiddenNetwork to avoid camelCase
>   staging: wilc1000: rename pstrNetworkInfo to avoid camelCase
>   staging: wilc1000: rename CfgScanResult to avoid camelCase
>   staging: wilc1000: rename au8ScanChanList to avoid camelCase
>   staging: wilc1000: fix line over 80 char in change_virtual_intf()
>   staging: wilc1000: fix line over 80 char in get_key() &
>     set_default_key()
>   staging: wilc1000: fix line over 80 char for cfg parse RX and TX
>     function
>   staging: wilc1000: fix line over 80 char in mgmt_tx_cancel_wait()
>   staging: wilc1000: rename pJoinParams to avoid camelCase
>   staging: wilc1000: fix line over 80 char in cfg_scan_result()
> 
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 329 +++++++++++-----------
>  1 file changed, 168 insertions(+), 161 deletions(-)
> 
