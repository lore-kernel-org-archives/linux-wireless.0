Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35556 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbbAWKCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 05:02:09 -0500
Message-ID: <1422007326.2728.25.camel@sipsolutions.net> (sfid-20150123_110252_011625_82F75EAD)
Subject: Re: [RFCv3 2/4] cfg80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 11:02:06 +0100
In-Reply-To: <1421757318-8343-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150120_133646_700499_A4EB7FB0)
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421757318-8343-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150120_133646_700499_A4EB7FB0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  /**
>   * enum nl80211_ext_feature_index - bit index of extended features.
> + * @NL80211_FEATURE_VHT_IBSS: This driver supports IBSS with VHT datarates.

I think that should be NL80211_EXT_FEATURE_VHT_IBSS to indicate where it
lives.

johannes

