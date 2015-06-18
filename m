Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbFRESD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 00:18:03 -0400
Date: Wed, 17 Jun 2015 21:18:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sunghoon Cho <ywhsbliss@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, Rachel.kim@atmel.com,
	dean.lee@atmel.com
Subject: Re: [PATCH 4/5] staging: wilc1000: remove prohibited spaces.
Message-ID: <20150618041802.GA10617@kroah.com> (sfid-20150618_061808_168612_2F86B7E8)
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
 <0d07f1a77b401c709fb8ae4be248f5e27b20e688.1434519635.git.ywhsbliss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0d07f1a77b401c709fb8ae4be248f5e27b20e688.1434519635.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2015 at 02:42:35PM +0900, Sunghoon Cho wrote:
> This patch removes the warnings on the prohibited spaces between
> function name and open parenthesis.
> 
> Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> index 96e4d5c..3307439 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> +++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
> @@ -80,9 +80,9 @@ struct WILC_WFI_stats {
>   * LPC3131 which is important to get the MAC start status when you are blocked
>   * inside linux_wlan_firmware_download() which blocks mac_open().
>   */
> -#if defined (NM73131_0_BOARD)
> +#if defined(NM73131_0_BOARD)
>   #define RX_BH_TYPE  RX_BH_KTHREAD
> -#elif defined (PANDA_BOARD)
> +#elif defined(PANDA_BOARD)
>   #define RX_BH_TYPE  RX_BH_THREADED_IRQ
>  #else
>   #define RX_BH_TYPE  RX_BH_KTHREAD
> -- 
> 1.9.1

Doesn't apply properly, please rebase and resend.

thanks,

greg k-h
