Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37676 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890Ab1DLKof (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 06:44:35 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 03:44:10 -0700
Date: Tue, 12 Apr 2011 16:14:39 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath9k_hw: Fix AR9382 beacon distribution in IBSS
Message-ID: <20110412104438.GA7436@vmraj-lnx.users.atheros.com>
References: <1302533551-27462-1-git-send-email-rmanoharan@atheros.com>
 <1302533551-27462-4-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1302533551-27462-4-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 11, 2011 at 08:22:31PM +0530, Rajkumar Manoharan wrote:
> Update AR9003 mac_core table to fix imbalance
> beacon distribution of AR9382.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
>  .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> index f915a3d..46ecb32 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> @@ -1508,9 +1508,9 @@ static const u32 ar9300_2p2_mac_core[][2] = {
>  	{0x000081f8, 0x00000000},
>  	{0x000081fc, 0x00000000},
>  	{0x00008240, 0x00100000},
> -	{0x00008244, 0x0010f424},
> +	{0x00008244, 0x0010f400},
>  	{0x00008248, 0x00000800},
> -	{0x0000824c, 0x0001e848},
> +	{0x0000824c, 0x0001e800},
>  	{0x00008250, 0x00000000},
>  	{0x00008254, 0x00000000},
>  	{0x00008258, 0x00000000},
John,

Please drop this patch, since we found IOT issues with this patch.

--
Rajkumar
