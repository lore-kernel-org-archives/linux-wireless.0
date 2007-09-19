Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44509
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbXISWc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 18:32:57 -0400
Date: Wed, 19 Sep 2007 15:32:56 -0700 (PDT)
Message-Id: <20070919.153256.10296833.davem@davemloft.net>
To: dsd@gentoo.org
Cc: linville@tuxdriver.com, jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
Subject: Re: Please pull 'z1211' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <46F1A23D.8080606@gentoo.org>
References: <46F19DD0.2050605@gentoo.org>
	<20070919.151446.116351108.davem@davemloft.net>
	<46F1A23D.8080606@gentoo.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Drake <dsd@gentoo.org>
Date: Wed, 19 Sep 2007 23:27:09 +0100

> zd1211rw-mac80211 does not currently add anything to the user experience 
> over the existing driver, other than automatic rate adaption which is 
> nice but hasn't proven itself to be of much importance given that the 
> existing driver has lots of happy users and has never done it.

Ok.

> Also, this merge has been proposed in a form other than what me and 
> Ulrich were envisioning (at least from earlier discussions). We want to 
> convert drivers/net/wireless/zd1211rw to mac80211 directly. This would 
> also avoid a rename and I think would save some hassle.
> 
> Sorry to be a pain, but I really would like some more time to catch up 
> and make some last changes. I haven't yet even looked at Johannes' 
> minimal filter flags implementation in the driver or Michael's fix.
> 
> Would you agree to let this wait until 2.6.25? You can hold me to that, 
> although Ulrich should also comment on if he thinks he'd be ready by then.

Fair enough, I'll remove the Z1211 driver during my next rebase.
