Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64399 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaGUIPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 04:15:24 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, joe@perches.com,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 15/30] carl9170: remove unnecessary break after return
Date: Mon, 21 Jul 2014 10:15:07 +0200
Message-ID: <3022358.4W3VLEbhdR@blech> (sfid-20140721_101553_468929_6C705A0F)
In-Reply-To: <1405866332-24652-6-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be> <1405866332-24652-6-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, July 20, 2014 04:25:16 PM Fabian Frederick wrote:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
>  drivers/net/wireless/ath/carl9170/phy.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
> index ab4ee7d..b80b213 100644
> --- a/drivers/net/wireless/ath/carl9170/phy.c
> +++ b/drivers/net/wireless/ath/carl9170/phy.c
> @@ -1139,7 +1139,6 @@ static int carl9170_set_freq_cal_data(struct ar9170 *ar,
>  
>  	default:
>  		return -EINVAL;
> -		break;
>  	}
>  
>  	for (; i >= 0; i--) {
> 

