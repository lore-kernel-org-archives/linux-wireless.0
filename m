Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50564
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752997AbYISXUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 19:20:46 -0400
Date: Fri, 19 Sep 2008 16:20:34 -0700 (PDT)
Message-Id: <20080919.162034.132320061.davem@davemloft.net> (sfid-20080920_012051_917192_526DCDD4)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request wireless-next-2.6 2008-09-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080918140953.GE4552@tuxdriver.com>
References: <20080918140953.GE4552@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 18 Sep 2008 10:09:54 -0400

> Here is another round of stuff for 2.6.28.  Included in this is the
> support for the new userland component for regulatory enforcement.
> There is also a Kconfig option to preserve regulatory behavior
> compatible with earlier kernels.  Also included is another huge round of
> mac80211 cleanups, etc from Johannes and a smattering of other bits.
 ...
> The following changes since commit 63f2c0464875b6ef2132cecb19b2a5abbf061227:
>   Stephen Rothwell (1):
>         net: ip_vs_proto_{tcp,udp} build fix
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git master

Pulled and will push back out to net-next-2.6 after build tests complete.

Thanks!
