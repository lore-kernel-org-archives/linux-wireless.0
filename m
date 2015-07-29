Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbbG2Uuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 16:50:46 -0400
Date: Wed, 29 Jul 2015 13:50:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 06/21] staging: wilc1000: remove the warnings on
 unnecessary braces
Message-ID: <20150729205045.GA25633@kroah.com> (sfid-20150729_225049_784233_2144FA23)
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
 <1438073261-28315-7-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438073261-28315-7-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 28, 2015 at 05:47:25PM +0900, Tony Cho wrote:
> This patch removes the warnings reported by checkpatch.pl on {} not
> necessary for the single statement blocks.
> 
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/staging/wilc1000/wilc_sdio.c | 28 ++++++++++------------------
>  1 file changed, 10 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> index 6e865d4..967df95 100644
> --- a/drivers/staging/wilc1000/wilc_sdio.c
> +++ b/drivers/staging/wilc1000/wilc_sdio.c
> @@ -106,6 +106,7 @@ static int sdio_set_func0_csa_address_byte0(uint32_t adr)
>  _fail_:
>  	return 0;
>  }
> +

That's not what this change does :(

I'll let this go, but be more careful next time please...

greg k-h
