Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34249 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbbJ1HVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:21:42 -0400
Received: by padhk11 with SMTP id hk11so248677736pad.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2015 00:21:42 -0700 (PDT)
Date: Wed, 28 Oct 2015 12:51:13 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 06/80] staging: wilc1000: host_interface: removes unused
 functions
Message-ID: <20151028072113.GD3649@sudip-pc> (sfid-20151028_082145_876364_24998B10)
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
 <1446015640-29398-6-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446015640-29398-6-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2015 at 03:59:26PM +0900, Glen Lee wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch removes unused functions at host_interface files.
>  - host_int_send_join_leave_info_to_host
>  - host_int_send_network_info_to_host
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 11 ----------
>  drivers/staging/wilc1000/host_interface.h | 34 -------------------------------
>  2 files changed, 45 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index c3826eb..7f29abd 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -4037,11 +4037,6 @@ s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
>  	return result;
>  }
>  
> -void host_int_send_join_leave_info_to_host
> -	(u16 assocId, u8 *stationAddr, bool joining)
> -{
> -}
> -
>  static void GetPeriodicRSSI(unsigned long arg)
>  {
>  	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
> @@ -4070,12 +4065,6 @@ static void GetPeriodicRSSI(unsigned long arg)
>  	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
>  }
>  
> -
> -void host_int_send_network_info_to_host
> -	(u8 *macStartAddress, u16 u16RxFrameLen, s8 s8Rssi)
> -{
> -}
> -
>  s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)

In my staging tree this is:
s32 host_int_init(struct host_if_drv **hif_drv_handler)

Is this patchseries dependent on some previous unapplied patch?

regards
sudip
