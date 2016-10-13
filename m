Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19891 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754338AbcJMLXL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 07:23:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6k1: add Dell OEM SDIO I/O for the Venue 8 Pro
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <147629570687.26062.4786752681864367162.stgit@localhost.localdomain>
References: <147629570687.26062.4786752681864367162.stgit@localhost.localdomain>
To: Alan Cox <alan@linux.intel.com>
CC: <linux-wireless@vger.kernel.org>
Message-ID: <3241f0db941049e3b2299d5d674bafb2@euamsexm01a.eu.qualcomm.com> (sfid-20161013_132314_761475_2CBC01C6)
Date: Thu, 13 Oct 2016 13:20:01 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Cox <alan@linux.intel.com> wrote:
> From: Adam Williamson <adamw@happyassassin.net>
> 
> SDIO ID 0271:0418
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Bugzilla-ID: https://bugzilla.kernel.org/show_bug.cgi?id=67921
> Reviewed-by: Steve deRosier <steve.derosier@lairdtech.com>
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
> index eab0ab9..76eb336 100644
> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
> @@ -1401,6 +1401,7 @@ static const struct sdio_device_id ath6kl_sdio_devices[] = {
>  	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x0))},
>  	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x1))},
>  	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x2))},
> +	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x18))},
>  	{},
>  };
>  

Patch applied to ath-current branch of ath.git, thanks.

1ea2643961b0 ath6kl: add Dell OEM SDIO I/O for the Venue 8 Pro

-- 
https://patchwork.kernel.org/patch/9373725/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
