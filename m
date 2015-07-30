Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34170 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbbG3MKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 08:10:41 -0400
Received: by pacan13 with SMTP id an13so23172245pac.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 05:10:41 -0700 (PDT)
Date: Thu, 30 Jul 2015 17:40:32 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH V2 3/5] staging: wilc1000: remove warnings on missing
 blank line
Message-ID: <20150730121032.GB12823@sudip-pc> (sfid-20150730_141045_227593_B641B63F)
References: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
 <1438247414-19708-4-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438247414-19708-4-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2015 at 06:10:12PM +0900, Tony Cho wrote:
> This patch removes the warnings reported by checkpatch.pl on missing
> a blank line after declarations.
> 
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
> V2: This patch doesn't have a difference with the first one. However,
> it's resent becasue not accepted with the 9th patch.
> ---
>  drivers/staging/wilc1000/wilc_sdio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
> index ee1cbd1..50be2a1 100644
> --- a/drivers/staging/wilc1000/wilc_sdio.c
> +++ b/drivers/staging/wilc1000/wilc_sdio.c
> @@ -780,6 +780,7 @@ static int sdio_clear_int_ext(uint32_t val)
>  
>  	if (g_sdio.has_thrpt_enh3) {
>  		uint32_t reg;
> +
>  		reg = val & ((1 << MAX_NUN_INT_THRPT_ENH2) - 1);
>  
>  		/* select VMM table 0 */
This patch will not apply. After your first patch (1/5)
if (g_sdio.has_thrpt_enh3) has become if(g_sdio.has_thrpt_enh3).

regards
sudip
