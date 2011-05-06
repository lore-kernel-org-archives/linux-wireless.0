Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32954 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1EFIUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 04:20:23 -0400
Subject: Re: [PATCH] mac80211: Fix build error when CONFIG_PM is not defined
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4dc3375f.3VdEfQKL1lidemOn%Larry.Finger@lwfinger.net>
References: <4dc3375f.3VdEfQKL1lidemOn%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 10:20:17 +0200
Message-ID: <1304670017.3595.0.camel@jlt3.sipsolutions.net> (sfid-20110506_102028_357271_E7A0A838)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-05 at 18:48 -0500, Larry Finger wrote:
> When mac80211 is built without CONFIG_PM being defined, the following errors
> are output:
> 
> net/mac80211/main.c: In function ‘ieee80211_register_hw’:
> net/mac80211/main.c:700: error: ‘const struct ieee80211_ops’ has no member named ‘suspend’
> net/mac80211/main.c:700: error: ‘const struct ieee80211_ops’ has no member named ‘resume’
> make[2]: *** [net/mac80211/main.o] Error 1
> make[1]: *** [net/mac80211] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [net] Error 2

Oh, what a stupid mistake, thanks!

johannes


