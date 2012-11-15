Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-1.exch022.serverdata.net ([206.225.164.184]:37769
	"EHLO HUB022-nj-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993256Ab2KOLBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 06:01:00 -0500
Message-ID: <50A4CB5B.6050201@posedge.com> (sfid-20121115_120108_966230_D3AA5B60)
Date: Thu, 15 Nov 2012 16:30:43 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v2 2/8] nl80211: add documentation for channel type
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net> <1352492254-29399-3-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1352492254-29399-3-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2012 01:47 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   include/uapi/linux/nl80211.h | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index d33d780..ac5c446 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2436,6 +2436,15 @@ enum nl80211_ac {
>   #define NL80211_TXQ_Q_BE	NL80211_AC_BE
>   #define NL80211_TXQ_Q_BK	NL80211_AC_BK
>
> +/**
> + * enum nl80211_channel_type - channel type
> + * @NL80211_CHAN_NO_HT: 20 MHz, non-HT channel
> + * @NL80211_CHAN_HT20: 20 MHz HT channel
> + * @NL80211_CHAN_HT40MINUS: HT40 channel, secondary channel
> + *	below the control channel
> + * @NL80211_CHAN_HT40PLUS: HT40 channel, secondary channel
> + *	below the control channel

Typo. above the control channel

> + */
>   enum nl80211_channel_type {
>   	NL80211_CHAN_NO_HT,
>   	NL80211_CHAN_HT20,
>
