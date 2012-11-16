Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:34794
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab2KPMVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 07:21:52 -0500
Message-ID: <50A62FDA.2070307@posedge.com> (sfid-20121116_132155_383981_A48625F4)
Date: Fri, 16 Nov 2012 17:51:46 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net> <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2012 01:47 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>

> + *
> + * @NL80211_CHAN_WIDTH_20_NOHT: 20 MHz, non-HT channel

Should we have NL80211_CHAN_WIDTH_LEGACY or rename 
NL80211_CHAN_WIDTH_20_NOHT to NL80211_CHAN_WIDTH_NOHT to cover non HT 
associations in both 2.4 & 5 GHz bands.

> + * @NL80211_CHAN_WIDTH_20: 20 MHz HT channel
> + * @NL80211_CHAN_WIDTH_40: 40 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
> + *	attribute must be provided as well
> + * @NL80211_CHAN_WIDTH_80: 80 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
> + *	attribute must be provided as well
> + * @NL80211_CHAN_WIDTH_160: 160 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
> + *	attribute must be provided as well
> + * @NL80211_CHAN_WIDTH_80P80: 80+80 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
> + *	and %NL80211_ATTR_CENTER_FREQ2 attributes must be provided as well
> + */
> +enum nl80211_chan_width {
> +	NL80211_CHAN_WIDTH_20_NOHT,
> +	NL80211_CHAN_WIDTH_20,
> +	NL80211_CHAN_WIDTH_40,
> +	NL80211_CHAN_WIDTH_80,
> +	NL80211_CHAN_WIDTH_160,
> +	NL80211_CHAN_WIDTH_80P80,
> +};
