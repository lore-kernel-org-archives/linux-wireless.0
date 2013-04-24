Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:50051 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758196Ab3DXKo7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 06:44:59 -0400
Message-ID: <1366800294.11111.7.camel@jlt4.sipsolutions.net> (sfid-20130424_124503_278699_003DD936)
Subject: Re: [RFC v2] cfg80211: Android P2P-Device workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 Apr 2013 12:44:54 +0200
In-Reply-To: <87mwso5jbx.fsf@purkki.adurom.net>
References: <1366791988-11309-1-git-send-email-johannes@sipsolutions.net>
	 <87mwso5jbx.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-24 at 13:11 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > +#ifndef CONFIG_CFG80211_ANDROID_P2P_HACK
> >  	if (WARN_ON(wdev->netdev))
> >  		return;
> > +#endif
> 
> With my favorite kernel macro, config_enabled(), you could get rid of
> quite a lot of the ugly ifdefs.

Yeah, but as long as this isn't going upstream I don't really want to
though since then it touches the code and is less obvious. Anyway we'll
see.

johannes

