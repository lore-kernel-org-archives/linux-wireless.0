Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41828 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1E3Eay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 00:30:54 -0400
Received: by iwn34 with SMTP id 34so2677652iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 21:30:53 -0700 (PDT)
Message-ID: <4DE31D7A.6080600@lwfinger.net> (sfid-20110530_063107_155910_5E983E61)
Date: Sun, 29 May 2011 23:30:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 04/27] rtlwifi: include mac80211.h from core.h
References: <20110529195022.16479.71762.stgit@localhost6.localdomain6> <20110529200434.16479.84395.stgit@localhost6.localdomain6>
In-Reply-To: <20110529200434.16479.84395.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2011 03:04 PM, Kalle Valo wrote:
> core.h references ieee80211_ops but doesn't include mac80211.h, which issues
> a warning once mac80211-compat.h is taken into use.
>
> Signed-off-by: Kalle Valo<kvalo@adurom.com>

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
>   drivers/net/wireless/rtlwifi/core.h |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/rtlwifi/core.h
> index 4b247db..f02824a 100644
> --- a/drivers/net/wireless/rtlwifi/core.h
> +++ b/drivers/net/wireless/rtlwifi/core.h
> @@ -30,6 +30,8 @@
>   #ifndef __RTL_CORE_H__
>   #define __RTL_CORE_H__
>
> +#include<net/mac80211.h>
> +
>   #define RTL_SUPPORTED_FILTERS		\
>   	(FIF_PROMISC_IN_BSS | \
>   	FIF_ALLMULTI | FIF_CONTROL | \
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

