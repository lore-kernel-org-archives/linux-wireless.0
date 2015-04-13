Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48069 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbbDMIJZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 04:09:25 -0400
Message-ID: <1428912560.2355.0.camel@sipsolutions.net> (sfid-20150413_100951_837149_7BB39793)
Subject: Re: [PATCH] net/wireless: CFG80211_WEXT_EXPORT requires wireless
 extensions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Mon, 13 Apr 2015 10:09:20 +0200
In-Reply-To: <4904912.VjuX4Pm71s@wuerfel>
References: <2303996.H1mYPouv05@wuerfel>
	 <1428733011.2139.1.camel@sipsolutions.net> <4904912.VjuX4Pm71s@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-04-11 at 22:41 +0200, Arnd Bergmann wrote:

> As Paul commented, it does work, and I have of course checked that my
> patch fixes the problem without introducing other build failures.

:-)
Ok, I learned something. I'm always careful with "select" because it has
some corner cases.

Anyway, my other patch is in net-next now, so it'll be fixed in a tree
near you soon :)

johannes

