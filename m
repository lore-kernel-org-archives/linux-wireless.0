Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:46170 "EHLO remote.erley.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753822AbcKWHrw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 02:47:52 -0500
Subject: Re: [PATCH 3/3][RESEND][RFC] nl80211/mac80211: Accept multiple RSSI
 thresholds for CQM
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
References: <1479810592-2474-1-git-send-email-andrew.zaborowski@intel.com>
 <1479810592-2474-4-git-send-email-andrew.zaborowski@intel.com>
From: Pat Erley <pat-lkml@erley.org>
Message-ID: <225569a5-5f54-fe1b-035a-e449b611a8bb@erley.org> (sfid-20161123_084756_142846_AB08E6CC)
Date: Tue, 22 Nov 2016 23:38:43 -0800
MIME-Version: 1.0
In-Reply-To: <1479810592-2474-4-git-send-email-andrew.zaborowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -502,6 +502,10 @@ struct ieee80211_mu_group_data {
>   *	implies disabled. As with the cfg80211 callback, a change here should
>   *	cause an event to be sent indicating where the current value is in
>   *	relation to the newly configured threshold.
> + * @cqm_rssi_low: Connection quality monitor RSSI lower threshold, a zero value
> + *	implies disabled.  This is an alternative mechanism to the single
> + *	threshold event and can't be enabled simultaneously.
> + * @cqm_rssi_low: Connection quality monitor RSSI upper threshold.

cqm_rssi_high
