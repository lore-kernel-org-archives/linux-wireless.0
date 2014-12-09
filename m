Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:37339 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLISgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 13:36:05 -0500
Date: Tue, 09 Dec 2014 13:36:02 -0500 (EST)
Message-Id: <20141209.133602.1849817956610567109.davem@davemloft.net> (sfid-20141209_193635_044855_05C1CAA7)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-12-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141203203432.GF2896@tuxdriver.com>
References: <20141203203432.GF2896@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 3 Dec 2014 15:34:33 -0500

> One last(?) batch of fixes hoping to make 3.18...
> 
> In this episode, we have another trio of rtlwifi fixes
> repairing a little more damage from the major update of the
> rtlwifi-family of drivers.  These editing mistakes caused some
> memory corruption and missed a flag critical to proper interrupt
> handling.  Together, these fix the kernel regression reported at
> https://bugzilla.kernel.org/show_bug.cgi?id=88951 by Catalin Iacob.
> 
> Please let me know if there are problems!

Unfortunately, this did not make it for 3.18, but I've pulled it into my
'net' tree which I'll merge into 'net-next' for the merge window.
