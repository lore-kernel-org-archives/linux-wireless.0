Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947022AbbGaUwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 16:52:14 -0400
Date: Fri, 31 Jul 2015 13:52:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shraddha Barke <shraddha.6596@gmail.com>
Cc: Dean Lee <dean.lee@atmel.com>, Rachel Kim <rachel.kim@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:wilc1000 :Remove typedef from struct
Message-ID: <20150731205213.GF1650@kroah.com> (sfid-20150731_225238_140827_599B8654)
References: <1438321127-8120-1-git-send-email-shraddha.6596@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438321127-8120-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2015 at 11:08:47AM +0530, Shraddha Barke wrote:
> This patch fixes the following checkpatch.pl warning:
> 
> WARNING: do not add new typedefs
> 
> Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 54eb8a1..d6ef6e1 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -88,7 +88,7 @@ typedef enum {
>  } tenuFrmSubtype;
>  
>  /* Basic Frame Classes */
> -typedef enum {
> +enum {
>  	CLASS1_FRAME_TYPE      = 0x00,
>  	CLASS2_FRAME_TYPE      = 0x01,
>  	CLASS3_FRAME_TYPE      = 0x02,

Did you test-build this change?
