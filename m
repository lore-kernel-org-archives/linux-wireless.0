Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:11684 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbeDLHnf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 03:43:35 -0400
Subject: Re: [PATCH] staging: wilc1000: Remove unnecessary braces {} around
 single statement block
To: Eyal Ilsar <edilsar@gmail.com>, <aditya.shankar@microchip.com>,
        <ganesh.krishna@microchip.com>, <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
References: <1523371795-5090-1-git-send-email-edilsar@gmail.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <4c3eeecd-ac80-a312-59cb-2b9432a5b5ae@microchip.com> (sfid-20180412_094350_203405_54F46AD0)
Date: Thu, 12 Apr 2018 10:43:32 +0300
MIME-Version: 1.0
In-Reply-To: <1523371795-5090-1-git-send-email-edilsar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10.04.2018 17:49, Eyal Ilsar wrote:
> Remove unnecessary braces {} around an 'if' statement block with a single 
> statement. Issue found by checkpatch.

You should add an empty line before "Signed-off" line as stated in [1]. I
would also add a space b/w your name and your email in Signed-off line as
is exemplified in [2].

[1]
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#the-canonical-patch-format
[2] https://www.kernel.org/doc/html/latest/process/sub
mitting-patches.html#developer-s-certificate-of-origin-1-1

> Signed-off-by: Eyal Ilsar<edilsar@gmail.com>
> ---
> This is part of my take on the Eudyptula challenge
> 
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index 205304c..325afe1 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -284,9 +284,8 @@ static void remove_network_from_shadow(struct timer_list *unused)
>  		}
>  	}
>  
> -	if (last_scanned_cnt != 0) {
> +	if (last_scanned_cnt != 0)
>  		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
> -	}
>  }
>  
>  static void clear_duringIP(struct timer_list *unused)
> 
