Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50365 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbZH3Wpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 18:45:38 -0400
Date: Sun, 30 Aug 2009 18:35:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] ipw2200: fix kconfig dependencies
Message-ID: <20090830223510.GB2087@tuxdriver.com>
References: <4A9ADFA1.5030706@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A9ADFA1.5030706@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 30, 2009 at 01:22:57PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig dependencies for ipw2x00 drivers, fixes build errors:
> 
> ERROR: "wiphy_free" [drivers/net/wireless/ipw2x00/libipw.ko] undefined!
> ERROR: "wiphy_unregister" [drivers/net/wireless/ipw2x00/libipw.ko] undefined!
> ERROR: "wiphy_new" [drivers/net/wireless/ipw2x00/libipw.ko] undefined!
> ERROR: "cfg80211_wext_giwname" [drivers/net/wireless/ipw2x00/ipw2200.ko] undefined!
> ERROR: "wiphy_register" [drivers/net/wireless/ipw2x00/ipw2200.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Oops!  My bad...thanks, Randy!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
