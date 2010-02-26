Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49575
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935416Ab0BZH1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 02:27:32 -0500
Date: Thu, 25 Feb 2010 23:27:48 -0800 (PST)
Message-Id: <20100225.232748.200313445.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2010-02-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100222185638.GC2988@tuxdriver.com>
References: <20100222185638.GC2988@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 22 Feb 2010 13:56:38 -0500

> Here is one more big batch of wireless bits intended for 2.6.34.  Along
> with the usual variety of driver fixes are some mac80211 bits from
> Johannes, a number of iwlwifi updates from Intel, and a big batch of of
> wl1271 bits from Nokia.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.

There were two conflicts I had to resolve (some declarations in in
iwl-core.h and one of the rt* driver PCI ID tables).

Please double-check my work when I push this out to net-next-2.6

Thanks!
