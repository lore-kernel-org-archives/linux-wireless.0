Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52913 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753666AbXGRO6X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 10:58:23 -0400
Date: Wed, 18 Jul 2007 16:58:38 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: patches ping
Message-ID: <20070718165838.449b33cd@griffin.suse.cz>
In-Reply-To: <1184674109.3773.70.camel@johannes.berg>
References: <1184674109.3773.70.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 17 Jul 2007 14:08:29 +0200, Johannes Berg wrote:
> What happened to my patches
> 
>  * mac80211: regdomain.c needs to include ieee80211_i.h

I don't have this one. Could you repost it, please?

>  * mac80211: kill PRISM2_HOSTAPD_UPDATE_IF sub-ioctl
>  * mac80211: move wpa trigger to debugfs
>  * mac80211: kill PRISM2_PARAM_AP_AUTH_ALGS

They are targeted for wireless-dev and are on my pending list. I need
to do something fundamental with mac80211 dev tree first as it is
becoming unmanageable. Please stay tuned.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
