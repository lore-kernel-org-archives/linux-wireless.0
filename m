Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:29393 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbeCZIkr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 04:40:47 -0400
Subject: Re: [PATCH 0/9] staging: wilc1000: fix memory leaks and checkpatch
 reported issues
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <873a109f-d738-b59a-85af-1d11e9a86f3a@microchip.com> (sfid-20180326_104051_329068_CAC3F929)
Date: Mon, 26 Mar 2018 11:40:43 +0300
MIME-Version: 1.0
In-Reply-To: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

On 23.03.2018 17:08, Ajay Singh wrote:
> This patch series contains changes to fix memory leaks, avoid NULL pointer
> exceptions and checkpatch reported issue fixes.
> 
> Ajay Singh (9):
>   staging: wilc1000: remove unused global variables related to p2p
>   staging: wilc1000: avoid 'NULL' pointer access in
>     wilc_network_info_received()
>   staging: wilc1000: free allocated memory in edit and add station
>     functions
>   staging: wilc1000: free memory allocated in add wep key functions
>   staging: wilc1000: free allocated memory after processing
>     wilc_send_config_pkt()
>   staging: wilc1000: fix to free allocated memory in wilc_add_ptk()
>   staging: wilc1000: free allocated memory in wilc_add_rx_gtk()
>   staging: wilc1000: split handle_rcvd_gnrl_async_info() to avoid
>     leading tabs
>   staging: wilc1000: free memory allocated for general info message from
>     firmware
> 
>  drivers/staging/wilc1000/host_interface.c | 421 +++++++++++++++---------------
>  1 file changed, 204 insertions(+), 217 deletions(-)
> 
