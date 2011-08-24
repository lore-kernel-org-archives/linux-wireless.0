Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44216 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1HXOa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:30:27 -0400
Date: Wed, 24 Aug 2011 20:00:40 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: Re: [PATCH 1/3] ath6kl: Add initial debugfs changes
Message-ID: <20110824143039.GA25267@vasanth-laptop> (sfid-20110824_163031_249644_3B9F3069)
References: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 07:55:34PM +0530, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/Kconfig |    6 ++++++
>  drivers/net/wireless/ath/ath6kl/core.h  |    1 +
>  drivers/net/wireless/ath/ath6kl/debug.c |   13 +++++++++++++
>  drivers/net/wireless/ath/ath6kl/debug.h |    9 +++++++++
>  drivers/net/wireless/ath/ath6kl/init.c  |    6 ++++++
>  5 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
> index 3d5f8be..ea9387b 100644
> --- a/drivers/net/wireless/ath/ath6kl/Kconfig
> +++ b/drivers/net/wireless/ath/ath6kl/Kconfig
> @@ -13,3 +13,9 @@ config ATH6KL_DEBUG
>  	depends on ATH6KL
>  	---help---
>  	  Enables debug support
> +config ATH6KL_DEBUGFS
> +	bool "ath6kl debugfs"
> +	depends on ATH6KL_DEBUG && DEBUG_FS

ATH6KL_DEBUGFS can be independent of ATH6KL_DEBUG. I'll send v2
fixing this.

Vasanth
