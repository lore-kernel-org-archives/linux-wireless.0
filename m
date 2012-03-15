Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2COSum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:50:42 -0400
Subject: Re: [RFC 1/2] cfg80211:  Add framework to support ethtool stats.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331833159-12694-1-git-send-email-greearb@candelatech.com> (sfid-20120315_183939_019754_FB9DFB9F)
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com>
	 (sfid-20120315_183939_019754_FB9DFB9F)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 19:50:42 +0100
Message-ID: <1331837442.3432.35.camel@jlt3.sipsolutions.net> (sfid-20120315_195046_813296_88698329)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 10:39 -0700, greearb@candelatech.com wrote:

> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -379,6 +379,8 @@ struct sta_info {
>  	struct ieee80211_sta sta;
>  };
>  
> +#define NUM_STA_INFO_STATS 12
> +

That doesn't seem to belong into this patch?

johannes

