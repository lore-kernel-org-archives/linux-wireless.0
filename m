Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34035 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbbFWLnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 07:43:19 -0400
Received: by pabvl15 with SMTP id vl15so5523673pab.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2015 04:43:19 -0700 (PDT)
Date: Tue, 23 Jun 2015 17:13:08 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: wilc_wfi_netdevice.c: remove
 commented codes
Message-ID: <20150623114146.GA9221@sudip-PC> (sfid-20150623_134328_361503_56DA56CD)
References: <1435018667-12507-1-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435018667-12507-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 23, 2015 at 09:17:44AM +0900, Chaehyun Lim wrote:
> Remove commented codes.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_netdevice.c | 21 ---------------------
>  1 file changed, 21 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
> index 170ca65..478cd2b 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
<snip>
> @@ -931,10 +914,6 @@ int WILC_WFI_InitModule(void)
>  
>  	WILC_memset(priv[0]->au8AssociatedBss, 0xFF, ETH_ALEN);
>  
> -
> -	/* ret = host_int_init(&priv[0]->hWILCWFIDrv); */
> -	/*copy handle to the other driver*/
> -	/* priv[1]->hWILCWFIDrv = priv[0]->hWILCWFIDrv; */
>  	if (ret)
>  		PRINT_ER("Error Init Driver\n");
This is not applying. My file is having here:
if (ret) {
	PRINT_ER("Error Init Driver\n");
}

is this patch dependent on some prior patch which is not yet applied
to staging?

regards
sudip
