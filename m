Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5921 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbeDLIQ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 04:16:57 -0400
Subject: Re: [PATCH v2] staging: wilc1000: Remove unnecessary braces {} around
 single statement block
To: Eyal Ilsar <edilsar@gmail.com>, <aditya.shankar@microchip.com>,
        <ganesh.krishna@microchip.com>, <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1523371795-5090-1-git-send-email-edilsar@gmail.com>
 <1523519972-21017-1-git-send-email-edilsar@gmail.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <de5c65da-2bdb-19e1-db89-c5bd28b5df2f@microchip.com> (sfid-20180412_101723_657647_9B8F1EB3)
Date: Thu, 12 Apr 2018 11:16:55 +0300
MIME-Version: 1.0
In-Reply-To: <1523519972-21017-1-git-send-email-edilsar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12.04.2018 10:59, Eyal Ilsar wrote:
> Remove unnecessary braces {} around an 'if' statement block with a single 
> statement. Issue found by checkpatch.
> 
> Signed-off-by: Eyal Ilsar <edilsar@gmail.com>

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

> ---
> Added an empty line before the 'Signed-off-by' line and a space between the
> name and e-mail address within that line.
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
