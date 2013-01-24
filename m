Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41954 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab3AXVHc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 16:07:32 -0500
Received: by mail-ea0-f174.google.com with SMTP id 1so4037905eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2013 13:07:30 -0800 (PST)
References: <20130124205931.GB16252@localhost.localdomain> <20130124210028.GA22800@localhost.localdomain> <20130124210110.GB22800@localhost.localdomain> <20130124210155.GC22800@localhost.localdomain>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130124210155.GC22800@localhost.localdomain>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <8039F260-4BB4-4C3C-8616-B857484A136E@gmail.com> (sfid-20130124_220734_227929_B3C69B93)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 4/4] rt2x00: print queue parameters at debug level
Date: Thu, 24 Jan 2013 22:07:28 +0100
To: Stanislaw Gruszka <stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 24 jan. 2013, at 22:01, Stanislaw Gruszka <stf_xl@wp.pl> wrote:

> Those messages do not provide interesting information for average user,
> print them at debug level.
> 
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>


> ---
> drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index ed7a1bb..20c6ecc 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -731,9 +731,9 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw,
>    queue->aifs = params->aifs;
>    queue->txop = params->txop;
> 
> -    INFO(rt2x00dev,
> -         "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
> -         queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
> +    DEBUG(rt2x00dev,
> +          "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
> +          queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
> 
>    return 0;
> }
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
