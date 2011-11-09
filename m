Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:57443 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1KIHt6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 02:49:58 -0500
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: deprecate CFG80211_WEXT
References: <1320781153.24797.41.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 09 Nov 2011 09:49:54 +0200
In-Reply-To: <1320781153.24797.41.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Tue\, 08 Nov 2011 20\:39\:13 +0100")
Message-ID: <87ehxhag65.fsf@purkki.adurom.net> (sfid-20111109_085001_175917_AFE02259)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Almost all wireless tools have transitioned to
> or at least added compatibility with nl80211 so
> there's no real need for CONFIG_CFG80211_WEXT
> any more. Mark it for removal, and also change
> the default to not be enabled.

Maybe CC lkml for more visibility?

-- 
Kalle Valo
