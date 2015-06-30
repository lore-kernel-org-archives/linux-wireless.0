Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28590 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbbF3JlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 05:41:13 -0400
Date: Tue, 30 Jun 2015 12:40:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dean Lee <dean.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, rachel.kim@atmel.com,
	chris.park@atmel.com, nicolas.ferre@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH 6/6] staging: wilc1000: delete unused value.
Message-ID: <20150630094052.GP28762@mwanda> (sfid-20150630_114117_836710_32F66001)
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
 <1435653278-5168-6-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435653278-5168-6-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2015 at 05:34:38PM +0900, Dean Lee wrote:
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 1b8991a..0772292 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -1946,7 +1946,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
>  
>  		wilc_bus_set_max_speed();
>  
> -		if (g_linux_wlan->oup.wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, 0)) {
> +		if (g_linux_wlan->oup.wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, NULL)) {
>  			int size;
>  			char Firmware_ver[20];
>  			size = g_linux_wlan->oup.wlan_cfg_get_value(

This change is not in the patch description.

regards,
dan carpenter

