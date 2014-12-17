Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38218 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaLQUXk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 15:23:40 -0500
Message-ID: <1418847813.2135.29.camel@sipsolutions.net> (sfid-20141217_212349_463875_917570C9)
Subject: Re: [PATCH] MAINTAINERS: changes for wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net
Date: Wed, 17 Dec 2014 21:23:33 +0100
In-Reply-To: <5491D991.30908@broadcom.com> (sfid-20141217_202931_110924_F697E311)
References: <1418836025-9035-1-git-send-email-linville@tuxdriver.com>
	 <5491D991.30908@broadcom.com> (sfid-20141217_202931_110924_F697E311)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-17 at 20:29 +0100, Arend van Spriel wrote:

> > +NETWORKING DRIVERS (WIRELESS)
> > +M:	Kalle Valo<kvalo@codeaurora.org>
> > +L:	linux-wireless@vger.kernel.org
> > +Q:	http://patchwork.kernel.org/project/linux-wireless/list/
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/
> > +S:	Maintained
> > +F:	drivers/net/wireless/
> 
> So what about the other paths that were in "NETWORKING [WIRELESS]". 
> Couple of them are obviously maintained by Johannes, but..

The remaining ones are probably just wext, and nobody cares any more ...
I guess they're orphaned. If anyone really really really needs to have a
patch against them, and we actually end up wanting it, I'm sure we can
figure something out :)

johannes

