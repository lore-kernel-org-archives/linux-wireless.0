Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60163 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbbKWSXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 13:23:47 -0500
Subject: Re: [PATCH 2/4] staging: wilc1000: Fix typo in host_interface.c
To: Masanari Iida <standby24x7@gmail.com>, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	austin.shin@atmel.com, johnny.kim@atmel.com,
	linux-wireless@vger.kernel.org
References: <1448286080-14787-1-git-send-email-standby24x7@gmail.com>
 <1448286080-14787-2-git-send-email-standby24x7@gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <565359AC.7020505@infradead.org> (sfid-20151123_192350_700048_DAB64E33)
Date: Mon, 23 Nov 2015 10:23:40 -0800
MIME-Version: 1.0
In-Reply-To: <1448286080-14787-2-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/15 05:41, Masanari Iida wrote:
> This patch fix spelling typo in host_interface.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index d5b7725..b9f9541 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -844,7 +844,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
>  	}
>  
>  	if (g_obtainingIP || connecting) {
> -		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
> +		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP addresses is obtained\n");

		                                                                 address

>  		PRINT_ER("Don't do obss scan\n");
>  		result = -EBUSY;
>  		goto ERRORHANDLER;

> @@ -2518,7 +2518,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
>  	}
>  
>  	if (g_obtainingIP || connecting) {
> -		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
> +		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP addresses is obtained\n");

		                                                                 address

>  		result = -EBUSY;
>  		goto ERRORHANDLER;
>  	}


-- 
~Randy
