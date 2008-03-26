Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58294
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757284AbYCZAnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 20:43:21 -0400
Date: Tue, 25 Mar 2008 17:43:16 -0700 (PDT)
Message-Id: <20080325.174316.115119935.davem@davemloft.net> (sfid-20080326_004328_081974_7BF62B16)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6.26 2008-03-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080325211557.GA20488@tuxdriver.com>
References: <20080325211557.GA20488@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 25 Mar 2008 17:15:57 -0400

> Here is the latest package of wireless changes for 2.6.26.  Included are
> libertas and iwlwifi driver updates, some mac80211 updates, a few rt2x00
> driver updates, and a handful of odds and ends.

Pulled and pushed out to net-2.6.26, thanks!

> There will be one minor merge conflict in drivers/net/wireless/b43/dma.c
> when you merge this with the 2.6.25 fixes I posted yesterday.  Just
> take both sets of changes -- it is pretty obvious.

Thanks will keep that in mind.
