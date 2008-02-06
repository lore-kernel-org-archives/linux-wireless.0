Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3352 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760211AbYBFCdE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 21:33:04 -0500
Date: Tue, 5 Feb 2008 21:27:37 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] at76_usb: Add ID for Uniden PCW100
Message-ID: <20080206022737.GL4252@tuxdriver.com> (sfid-20080206_023309_282657_9951F583)
References: <20080204050518.2696.50289.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080204050518.2696.50289.stgit@dv.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 04, 2008 at 12:05:19AM -0500, Pavel Roskin wrote:
> Tested and reported by Lior Silberman.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
> 
>  drivers/net/wireless/at76_usb.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
> index d2e3c55..b95718a 100644
> --- a/drivers/net/wireless/at76_usb.c
> +++ b/drivers/net/wireless/at76_usb.c
> @@ -191,6 +191,8 @@ static struct usb_device_id dev_table[] = {
>  	{USB_DEVICE(0x07aa, 0x0011), USB_DEVICE_DATA(BOARD_503)},
>  	/* Corega Wireless LAN USB-11 mini2 */
>  	{USB_DEVICE(0x07aa, 0x0018), USB_DEVICE_DATA(BOARD_503)},
> +	/* Uniden PCW100 */
> +	{USB_DEVICE(0x05dd, 0xff35), USB_DEVICE_DATA(BOARD_503)},
>  	/*
>  	 * at76c503-rfmd-acc
>  	 */

Thanks for the patch!

Any word on when the mac80211 port of at76 will resurface?  I'd love
to get it into my tree for 2.6.26.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
