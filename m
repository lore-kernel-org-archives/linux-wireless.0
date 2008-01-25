Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:36428 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754490AbYAYBUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 20:20:25 -0500
From: David Brownell <david-b@pacbell.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 09/14] [usbnet] add driver_priv pointer to 'struct usbnet'
Date: Thu, 24 Jan 2008 16:59:36 -0800
Cc: linux-wireless@vger.kernel.org, bjd@jooz.net,
	netdev@vger.kernel.org
References: <20080120001432.25718.30378.stgit@fate.lan>
In-Reply-To: <20080120001432.25718.30378.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801241659.36850.david-b@pacbell.net> (sfid-20080125_012046_965708_0B54759A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 19 January 2008, Jussi Kivilinna wrote:
> Add a private data pointer to usbnet for rndis_wext module to use.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
> 
>  drivers/net/usb/usbnet.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/usb/usbnet.h b/drivers/net/usb/usbnet.h
> index 29ab92e..0b4bf09 100644
> --- a/drivers/net/usb/usbnet.h
> +++ b/drivers/net/usb/usbnet.h
> @@ -31,6 +31,7 @@ struct usbnet {
>  	struct usb_interface	*intf;
>  	struct driver_info	*driver_info;
>  	const char		*driver_name;
> +	void			*driver_priv;
>  	wait_queue_head_t	*wait;
>  	struct mutex		phy_mutex;
>  	unsigned char		suspend_count;
> 


