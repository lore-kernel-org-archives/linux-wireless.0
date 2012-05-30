Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:47575 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757149Ab2E3IOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 04:14:06 -0400
Message-ID: <1338365645.28696.0.camel@joe2Laptop> (sfid-20120530_101418_287316_36B67F3C)
Subject: Re: [PATCH] ath6kl: support changing dtim period on AP mode
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com,
	Etay Luz <eluz@qca.qualcomm.com>
Date: Wed, 30 May 2012 01:14:05 -0700
In-Reply-To: <1338363787-12314-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1338363787-12314-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 10:43 +0300, Kalle Valo wrote:
> +	ret = ath6kl_wmi_ap_set_dtim_cmd(ar->wmi, info->dtim_period);
> +
> +	/* ignore error, just print a warning and continue normally */
> +	if (ret)
> +		ath6kl_warn("Failed to set dtim_period in beacon: %d", ret);

missing newline termination


