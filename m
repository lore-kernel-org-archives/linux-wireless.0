Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2F1SGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 14:06:54 -0400
Message-ID: <1340906800.4491.48.camel@jlt3.sipsolutions.net> (sfid-20120628_200658_287687_3F5AC7E9)
Subject: Re: [RFC 60g 4/5] wireless: 60g protocol constants
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 28 Jun 2012 20:06:40 +0200
In-Reply-To: <1340882220-31768-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120628_131807_042627_0D3E4ADF)
References: <1340882220-31768-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1340882220-31768-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 (sfid-20120628_131807_042627_0D3E4ADF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 14:16 +0300, Vladimir Kondratiev wrote:

> @@ -1133,7 +1163,6 @@ struct ieee80211_ht_operation {
>  #define IEEE80211_SPCT_MSR_RPRT_TYPE_CCA	1
>  #define IEEE80211_SPCT_MSR_RPRT_TYPE_RPI	2
>  
> -
>  /* 802.11g ERP information element */
>  #define WLAN_ERP_NON_ERP_PRESENT (1<<0)
>  #define WLAN_ERP_USE_PROTECTION (1<<1)

spurious change?

> @@ -1196,6 +1235,17 @@ enum ieee80211_statuscode {
>  	WLAN_STATUS_ANTI_CLOG_REQUIRED = 76,
>  	WLAN_STATUS_FCG_NOT_SUPP = 78,
>  	WLAN_STATUS_STA_NO_TBTT = 78,
> +	/* 802.11ad */
> +	WLAN_STATUS_REJECTED_WITH_SUGGESTED_CHANGES		= 39,
> +	WLAN_STATUS_REJECTED_FOR_DELAY_PERIOD			= 47,

I think you should match the surrounding style ...

> @@ -1352,6 +1402,39 @@ enum ieee80211_eid {
>  	WLAN_EID_DSE_REGISTERED_LOCATION = 58,
>  	WLAN_EID_SUPPORTED_REGULATORY_CLASSES = 59,
>  	WLAN_EID_EXT_CHANSWITCH_ANN = 60,
> +	/* 802.11ad */
> +	WLAN_EID_NON_TX_BSSID_CAP		=  83,

ditto

johannes

