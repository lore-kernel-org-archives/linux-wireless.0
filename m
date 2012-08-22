Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731Ab2HVJMU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 05:12:20 -0400
Date: Wed, 22 Aug 2012 11:11:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <dgolle@allnet.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: add MediaTek/RaLink Rt3352 WiSoC
Message-ID: <20120822091158.GB4959@redhat.com> (sfid-20120822_111226_903263_6A1C1DA4)
References: <20120821231100.GA13890@earthship.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120821231100.GA13890@earthship.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please keep version (PATCH vX in subject) to do not confuse
patches.

On Wed, Aug 22, 2012 at 02:11:11AM +0300, Daniel Golle wrote:
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Signed-off-by: Daniel Golle <dgolle@allnet.de>

How do you know what to write to each RF/BBP register? I guess patch
is based on vendor driver, right? Where I can find it, if I would
like to compare it with this patch?

> +	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
> +		rt2x00_set_field8(&rfcsr, RFCSR17_CODE,
> +				  FREQ_OFFSET_BOUND);
Not needed line break.

> +	if ( rt2x00dev->default_ant.tx_chain_num == 1 )
Coding style.

> +	if ( rt2x00dev->default_ant.rx_chain_num == 1 )
The same.

> +	}
> +	else
> +	{
Again coding style.

> +		else if (rt2x00_rt(rt2x00dev, RT3352))
> +			rt2800_register_write(rt2x00dev, TX_SW_CFG0,
> +					      0x00000402);
Is possible to describe what does it mean?

Thanks
Stanislaw
