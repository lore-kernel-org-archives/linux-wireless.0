Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16871 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2AXLoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 06:44:23 -0500
Message-ID: <4F1E998F.2000507@qca.qualcomm.com> (sfid-20120124_124426_721809_F23D78BB)
Date: Tue, 24 Jan 2012 13:44:15 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 4/8] ath6kl: Move WOW patterns config code to a separate
 function.
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com> <1327066544-23779-5-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1327066544-23779-5-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2012 03:35 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Move the user provided WOW patterns configuration code
> from ath6kl_wow_suspend() to a separate function called
> ath6kl_add_usr_wow_patterns().
> 
> It gives more modularity to the existing code.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

> +static int ath6kl_add_usr_wow_patterns(struct ath6kl *ar,
> +				       struct ath6kl_vif *vif,
> +				       struct cfg80211_wowlan *wow,
> +				       u32 *filter)
> +{

ath6kl_wow_usr()?

Kalle
