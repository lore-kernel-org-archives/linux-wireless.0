Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33445 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbcANLAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 06:00:05 -0500
Message-ID: <1452769200.2444.5.camel@sipsolutions.net> (sfid-20160114_120009_335067_7D9CC06A)
Subject: Re: [RFC V2 1/3] nl80211: add extended feature for BSS selection
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 14 Jan 2016 12:00:00 +0100
In-Reply-To: <1452678583-20086-2-git-send-email-arend@broadcom.com>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
	 <1452678583-20086-2-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-13 at 10:49 +0100, Arend van Spriel wrote:
> 
> +enum nl80211_bss_select_primitive {
> +	NL80211_BSS_SELECT_RSSI,
> +	NL80211_BSS_SELECT_BAND_PREF,
> +	NL80211_BSS_SELECT_ADJUST_RSSI,
> +	/* add other primitives before this one */
> +	NUM_NL80211_BSS_SELECT
> +};
> 
Why not use enum nl80211_attr_bss_select from the next patch for this?

johannes
