Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56567 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab1JLSas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:30:48 -0400
Date: Wed, 12 Oct 2011 14:21:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 01/13] ath9k_hw: Updated ar9003 initval table for
 AR9380
Message-ID: <20111012182129.GC18764@tuxdriver.com> (sfid-20111012_203053_226303_F7D1B154)
References: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At least three of the patches in this series don't apply to either
wireless-next or wireless-testing.  Please only send me patch sets
that apply cleanly to recent kernels.

John

On Mon, Oct 10, 2011 at 11:21:06AM +0530, Rajkumar Manoharan wrote:
> The ar9003 table is updated to increase XLNA BIAS
> output driver strengh.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> index 08e9341..02be24e 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> @@ -24,11 +24,11 @@ static const u32 ar9300_2p2_radio_postamble[][5] = {
>  	{0x0001609c, 0x0dd08f29, 0x0dd08f29, 0x0b283f31, 0x0b283f31},
>  	{0x000160ac, 0xa4653c00, 0xa4653c00, 0x24652800, 0x24652800},
>  	{0x000160b0, 0x03284f3e, 0x03284f3e, 0x05d08f20, 0x05d08f20},
> -	{0x0001610c, 0x08000000, 0x00000000, 0x00000000, 0x00000000},
> +	{0x0001610c, 0xc8000000, 0xc0000000, 0xc0000000, 0xc0000000},
>  	{0x00016140, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
> -	{0x0001650c, 0x08000000, 0x00000000, 0x00000000, 0x00000000},
> +	{0x0001650c, 0xc8000000, 0xc0000000, 0xc0000000, 0xc0000000},
>  	{0x00016540, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
> -	{0x0001690c, 0x08000000, 0x00000000, 0x00000000, 0x00000000},
> +	{0x0001690c, 0xc8000000, 0xc0000000, 0xc0000000, 0xc0000000},
>  	{0x00016940, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
>  };
>  
> -- 
> 1.7.7
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
