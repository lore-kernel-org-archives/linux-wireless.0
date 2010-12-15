Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45424 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0LOQ0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 11:26:49 -0500
Subject: Re: [PATCH 00/22] rtl8192ce: Initial upload of driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4D08EA6D.6070106@lwfinger.net>
References: <4D08EA6D.6070106@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 17:26:40 +0100
Message-ID: <1292430400.3678.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

> If you prefer that it go to staging first, I will send it to GregKH, but since
> it uses mac80211, I think it is ready for wireless.

It looks pretty clean -- so personally, I don't think I'd mind it going
in directly.

Are you or somebody else planning to make changes to it though? It looks
like for example the config semaphore could easily be replaced by a
mutex for better debug, for example. Potentially, rate control could be
internalised with IEEE80211_HW_HAS_RATE_CONTROL as well, and some
similar minor things.

johannes

