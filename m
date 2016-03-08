Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10804 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbcCHL5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 06:57:42 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: Set global RRM capability
Date: Tue, 8 Mar 2016 11:57:37 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA6004A@hasmsx107.ger.corp.intel.com> (sfid-20160308_125744_677494_88AC1621)
References: <1457437561-19387-1-git-send-email-emmanuel.grumbach@intel.com>
In-Reply-To: <1457437561-19387-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Subject: [PATCH] mac80211: Set global RRM capability
> 
> Allow publishing RRM capabilities for features that are not HW dependent.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---

Err... please ignore..

>  net/mac80211/main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c index
> 8190bf2..0c9b621 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -548,7 +548,8 @@ struct ieee80211_hw
> *ieee80211_alloc_hw_nm(size_t priv_data_len,
>  			   NL80211_FEATURE_VIF_TXPOWER |
>  			   NL80211_FEATURE_MAC_ON_CREATE |
>  			   NL80211_FEATURE_USERSPACE_MPM |
> -			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;
> +			   NL80211_FEATURE_FULL_AP_CLIENT_STATE |
> +			   NL80211_EXT_FEATURE_RRM;
> 
>  	if (!ops->hw_scan)
>  		wiphy->features |=
> NL80211_FEATURE_LOW_PRIORITY_SCAN |
> --
> 2.5.0

