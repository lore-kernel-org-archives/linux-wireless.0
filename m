Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55754 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab3DXKLr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 06:11:47 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] cfg80211: Android P2P-Device workaround
References: <1366791988-11309-1-git-send-email-johannes@sipsolutions.net>
Date: Wed, 24 Apr 2013 13:11:46 +0300
In-Reply-To: <1366791988-11309-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Wed, 24 Apr 2013 10:26:28 +0200")
Message-ID: <87mwso5jbx.fsf@purkki.adurom.net> (sfid-20130424_121152_139270_18E162EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> +#ifndef CONFIG_CFG80211_ANDROID_P2P_HACK
>  	if (WARN_ON(wdev->netdev))
>  		return;
> +#endif

With my favorite kernel macro, config_enabled(), you could get rid of
quite a lot of the ugly ifdefs.

-- 
Kalle Valo
