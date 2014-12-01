Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17141 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaLAHsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 02:48:02 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ath10k: create a chip revision whielist
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
	<1417418266-21974-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 1 Dec 2014 09:47:33 +0200
In-Reply-To: <1417418266-21974-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 1 Dec 2014 08:17:44 +0100")
Message-ID: <8761dvreui.fsf@kamboji.qca.qualcomm.com> (sfid-20141201_084808_964322_684745CF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This will make it easier to extend and maintain
> list of supported hardware.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I fixed a typo: s/whielist/whitelist/

> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -479,7 +479,6 @@ struct ath10k {
>  		u32 id;
>  		const char *name;
>  		u32 patch_load_addr;
> -
>  		struct ath10k_hw_params_fw {
>  			const char *dir;
>  			const char *fw;

I removed this unnecessary change:

https://github.com/kvalo/ath/commit/bfa7b7948acaf7063cf4d664393b7f7a1c53b2e4

Because of my change there was also a simple conflict in patch 3:

https://github.com/kvalo/ath/commit/3487683c94495b6e0bbb1f3b19b3987b4ca2ff1f

-- 
Kalle Valo
