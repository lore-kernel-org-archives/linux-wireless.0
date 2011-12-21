Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53426 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730Ab1LUEl6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 23:41:58 -0500
Message-ID: <1324442516.20505.1.camel@joe2Laptop> (sfid-20111221_054201_395058_EEC16BD8)
Subject: Re: [PATCH 2/6] ath9k: make ath_mci_duty_cycle static
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 20 Dec 2011 20:41:56 -0800
In-Reply-To: <1324406771-7100-3-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1324406771-7100-3-git-send-email-rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-20 at 10:46 -0800, Luis R. Rodriguez wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
[]
> @@ -20,7 +20,7 @@
>  #include "ath9k.h"
>  #include "mci.h"
>  
> -u8 ath_mci_duty_cycle[] = { 0, 50, 60, 70, 80, 85, 90, 95, 98 };
> +static u8 ath_mci_duty_cycle[] = { 0, 50, 60, 70, 80, 85, 90, 95, 98 };

static const would be better.


