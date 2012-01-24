Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28881 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2AXLjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 06:39:22 -0500
Message-ID: <4F1E9865.5040004@qca.qualcomm.com> (sfid-20120124_123926_251653_2DF096DE)
Date: Tue, 24 Jan 2012 13:39:17 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 3/8] ath6kl: Add a new func to config default WOW patterns
 for non AP mode
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com> <1327066544-23779-4-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1327066544-23779-4-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2012 03:35 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> ath6kl_non_ap_add_default_wow_patterns() is added to configure
> the below default patterns when the system enters into WOW
> suspend in non AP mode.
> 
>   * Unicast packet pattern
>   * mDNS/SSDP/LLMNR pattern
> 
> This func will be called from ath6kl_wow_suspend().
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

> +static int ath6kl_non_ap_add_default_wow_patterns(struct ath6kl *ar,
> +						     struct ath6kl_vif *vif)
> +{

Maybe ath6kl_wow_sta() or something like that?

Kalle
