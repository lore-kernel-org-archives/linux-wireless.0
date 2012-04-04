Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34055 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab2DDLrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 07:47:52 -0400
Message-ID: <4F7C34DF.4090305@qca.qualcomm.com> (sfid-20120404_134755_247166_5D5CAB61)
Date: Wed, 4 Apr 2012 14:47:43 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Support net_stats.multicast
References: <1333442626-8038-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1333442626-8038-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2012 11:43 AM, Vasanthakumar Thiagarajan wrote:
> net_stats.multicast is updated with the count of received multicast packets.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Applied, thanks.

> -	}
> +	} else
> +		if (!is_broadcast_ether_addr(datap->h_dest))
> +			vif->net_stats.multicast++;

But I put else and if on the same line.

Kalle
