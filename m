Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36712 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbcCHJnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 04:43:12 -0500
Date: Tue, 8 Mar 2016 15:12:50 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org, Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: Re: [RFC v1] mac80211: Add support for per station rx stats histogram
Message-ID: <20160308094250.GA3685@atheros-ThinkPad-T61> (sfid-20160308_104317_973203_FDA87407)
References: <1457367809-13637-1-git-send-email-mohammed@qca.qualcomm.com>
 <1457424451.2283.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1457424451.2283.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, Mar 08, 2016 at 09:07:31AM +0100, Johannes Berg wrote:
> On Mon, 2016-03-07 at 21:53 +0530, Mohammed Shafi Shajakhan wrote:
> > 
> > +#define IEEE80211_HT_MCS_NUM		32
> > +#define IEEE80211_VHT_MCS_NUM		10
> > +#define IEEE80211_BW_NUM		4
> > +#define IEEE80211_NSS_NUM		4
> > +#define IEEE80211_GI_NUM		2
> > +#define IEEE80211_RATE_TABLE_NUM	320
> > +#define IEEE80211_LEGACY_RATE_NUM	12
> 
> > +#ifdef CONFIG_MAC80211_DEBUG_PER_STA_RX_STATS
> > +	u64 rx_legacy_pkt[IEEE80211_LEGACY_RATE_NUM];
> > +	u64 rx_ht_pkt[IEEE80211_HT_MCS_NUM];
> > +	u64 rx_vht_pkt[IEEE80211_VHT_MCS_NUM];
> > +	u64 rx_bw_pkt[IEEE80211_BW_NUM];
> > +	u64 rx_nss_pkt[IEEE80211_NSS_NUM];
> > +	u64 rx_gi_pkt[IEEE80211_GI_NUM];
> > +	u64 rx_rate_pkt[IEEE80211_RATE_TABLE_NUM];
> > +	u64 rx_legacy_byte[IEEE80211_LEGACY_RATE_NUM];
> > +	u64 rx_ht_byte[IEEE80211_HT_MCS_NUM];
> > +	u64 rx_vht_byte[IEEE80211_VHT_MCS_NUM];
> > +	u64 rx_bw_byte[IEEE80211_BW_NUM];
> > +	u64 rx_nss_byte[IEEE80211_NSS_NUM];
> > +	u64 rx_gi_byte[IEEE80211_GI_NUM];
> > +	u64 rx_rate_byte[IEEE80211_RATE_TABLE_NUM];
> > +#endif
> 
> Do you know how much data this is?!
> 
> Felix is going to kill both of us if I apply it.

[shafi] :-(

> 
> Please look at reviving my rate-statistics patch and do the remaining
> work in userspace:
> 
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/133172
>

[shafi] thank you, I will check this out.

regards,
shafi
