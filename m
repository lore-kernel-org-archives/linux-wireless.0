Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36700 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdKZR1x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Nov 2017 12:27:53 -0500
Date: Sun, 26 Nov 2017 22:57:47 +0530
From: Morgan Freeman <morganfreeman6991@gmail.com>
To: Ashish Kalra <eashishkalra@gmail.com>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removed Warning shown in checkpatch.pl for comment and
 white space
Message-ID: <20171126172747.GA6512@himanshu-Vostro-3559> (sfid-20171126_182824_529526_068AF2D5)
References: <20171126160550.3746-1-eashishkalra@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171126160550.3746-1-eashishkalra@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 26, 2017 at 09:35:50PM +0530, Ashish Kalra wrote:

Hi Ashish,

> checkpatch.pl was showing warnings due to incorrected space at the end
> of line and also not using * at start of second comment line, Corrected
> the same and now there is zero warning

Your patch subject is incorrect in many ways :

o It doesn't mention what driver you are cleaning.
o Don't mention the tool you used in the subject, in fact I would run
checkpatch.pl on your patch itself before sending.
o Always write commit log in *imperative mood*

Perhaps this might help you :
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes



> Signed-off-by: Ashish Kalra <eashishkalra@gmail.com>
> ---
>  drivers/bcma/driver_pcie2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/driver_pcie2.c b/drivers/bcma/driver_pcie2.c
> index b1a6e327cb23..cf889fc62ac7 100644
> --- a/drivers/bcma/driver_pcie2.c
> +++ b/drivers/bcma/driver_pcie2.c
> @@ -83,7 +83,8 @@ static void bcma_core_pcie2_hw_ltr_war(struct bcma_drv_pcie2 *pcie2)
>  		bcma_core_pcie2_set_ltr_vals(pcie2);
>  
>  		/* TODO:
> -		si_core_wrapperreg(pcie2, 3, 0x60, 0x8080, 0); */
> +		 *si_core_wrapperreg(pcie2, 3, 0x60, 0x8080, 0);
> +		 */
>  
>  		/* enable the LTR */
>  		devstsctr2 |= PCIE2_CAP_DEVSTSCTRL2_LTRENAB;
> -- 
> 2.14.1
> 
