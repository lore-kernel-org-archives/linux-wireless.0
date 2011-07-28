Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:33789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1G1FXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 01:23:55 -0400
Date: Wed, 27 Jul 2011 22:22:47 -0700 (PDT)
Message-Id: <20110727.222247.2000159983502866405.davem@davemloft.net> (sfid-20110728_072422_841059_AF6B885C)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2011-07-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110727184920.GB16431@tuxdriver.com>
References: <20110727184920.GB16431@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 27 Jul 2011 14:49:21 -0400

> Here is a handful of fixes intended for 3.1.  This includes a
> user-visible typo fix, a fix for a user after free in the new pn533
> NFC driver, a cfg80211 fix for a possible NULL pointer dereference,
> a fix for an invalid memory access in b43, and another b43 fix for
> a memory corruption problem.
> 
> On top of that b43 memory corruption fix, there is a patch to remove
> BROKEN from the B43_BCMA Kconfig entry, which is key to enabling
> support for some of the more modern Broadcom wireless hardware.
> I'm sure the Rafa©© (and a number of others) would love to see that
> merged while the 3.1 merge window is still open as well.
> 
> Please let me know if there are problems...

Yep, removing BROKEN from b43 seems reasonable.

Pulled, thanks!
