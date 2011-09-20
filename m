Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:34160 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1ITRsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 13:48:14 -0400
Date: Tue, 20 Sep 2011 13:47:05 -0400 (EDT)
Message-Id: <20110920.134705.385231251761546079.davem@davemloft.net> (sfid-20110920_194828_523689_D625A0F2)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless 2011-09-20
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110920170501.GE7800@tuxdriver.com>
References: <20110920170501.GE7800@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 20 Sep 2011 13:05:01 -0400

> This is a batch of fixes intended for 3.1.
> 
> Included is a set of Bluetooth fixes from Gustavo:
> 
> 	This is probably my unique pull request for 3.1, it fixes
> 	an regression with the HCI_INQUIRY flag, it was not getting
> 	cleaned after scan. Fix by Oliver Neukum. Also support for
> 	two new apple devices and a simple fix the to btwilink driver.
> 
> Also included is an iwlagn patch revert to avoid some AP crashes, an
> rt2800 patch to refactor some code that triggers a compiler bug, another
> rt2800 patch to correct an endian bug, a b43 fix to restore beaconing in
> ad-hoc mode, a regulatory enforcement fix for a problem that prevented
> multiple regulatory domain changes from beacons, a fix to use the proper
> rates in a probe request, and a fix for a deadlock that had crept into
> ipw2200 after an earlier patch.
> 
> Please let me know if there are problems!

Pulled, but this is very nearly "too much" this late in the game.

I recognize the issue that we've been stuck in a state of pseudo-limbo
up until a couple days ago, so I took this.
