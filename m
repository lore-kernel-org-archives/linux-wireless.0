Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53121 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbbAEJVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 04:21:09 -0500
Message-ID: <1420449663.1898.0.camel@sipsolutions.net> (sfid-20150105_102119_153805_439E32CA)
Subject: Re: [PATCH] cfg80211: check for carrier state only when offchanel
 CAC supported
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com, janusz.dziedzic@tieto.com
Date: Mon, 05 Jan 2015 10:21:03 +0100
In-Reply-To: <1419425236-17457-1-git-send-email-patila@marvell.com>
References: <1419425236-17457-1-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-24 at 04:47 -0800, Avinash Patil wrote:

> + * @NL80211_EXT_FEATURE_OFFCHAN_CAC: This device/driver supports
> + * offchannel Channel Availibility Check(CAC).

as Arend said, please indent (with a tab)

You're also mis-spelling "availability" :)

>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
>   */
>  enum nl80211_ext_feature_index {
>  
> +	NL80211_EXT_FEATURE_OFFCHAN_CAC,

Better add it before rather than after the blank line.

johannes

