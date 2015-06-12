Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbFLP1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 11:27:20 -0400
Date: Fri, 12 Jun 2015 08:27:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dean Lee <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: update TODO list
Message-ID: <20150612152720.GB26174@kroah.com> (sfid-20150612_172723_634570_8135D944)
References: <1434104591-5599-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434104591-5599-1-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 12, 2015 at 07:23:11PM +0900, Dean Lee wrote:
> remove complete OS wrapper functions.
> 
> Signed-off-by: Dean Lee <dean.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/TODO | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
> index 95199d8..e876008 100644
> --- a/drivers/staging/wilc1000/TODO
> +++ b/drivers/staging/wilc1000/TODO
> @@ -1,6 +1,5 @@
>  TODO:
>  - remove the defined feature as kernel versions
> -- remove OS wrapper functions
>  - remove custom debug and tracing functions
>  - rework comments and function headers(also coding style)
>  - replace all semaphores with mutexes or completions
> -- 
> 2.4.3

This isn't done yet, please make it the last patch in your series.

And are you sure you have removed them all?

thanks,

greg k-h
