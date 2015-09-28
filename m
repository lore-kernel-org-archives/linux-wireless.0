Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34284 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbI1SiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 14:38:08 -0400
Date: Tue, 29 Sep 2015 00:07:43 +0530
From: Chandra Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 2/2] drivers: staging: wilc1000: wilc_msgqueue.c: Remove
 code that no effect
Message-ID: <20150928183743.GA2879@gcs-HP-Notebook> (sfid-20150928_203825_767826_FC8998C2)
References: <1443464037-3591-1-git-send-email-csgorentla@gmail.com>
 <1443464037-3591-2-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443464037-3591-2-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please do not review this.  This is duplicate to -
[PATCH 2/2] drivers: staging: wilc1000: wilc_msgqueue.c: Remove ineffective code

On Mon, Sep 28, 2015 at 11:43:56PM +0530, Chandra S Gorentla wrote:
> Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_msgqueue.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> index a01ada4..1a411d3 100644
> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> @@ -133,11 +133,6 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
>  	down(&pHandle->hSem);
>  
>  	/* other non-timeout scenarios */
> -	if (result) {
> -		PRINT_ER("Non-timeout\n");
> -		return result;
> -	}
> -
>  	if (pHandle->bExiting) {
>  		PRINT_ER("pHandle fail\n");
>  		return -EFAULT;
> -- 
> 2.1.4
> 
