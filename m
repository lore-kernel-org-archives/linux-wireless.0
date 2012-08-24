Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:55706 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2HXTSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 15:18:47 -0400
Date: Fri, 24 Aug 2012 15:18:43 -0400 (EDT)
Message-Id: <20120824.151843.2224438277546850875.davem@davemloft.net> (sfid-20120824_211933_073096_829BA8B5)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-08-24
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120824161330.GC27147@tuxdriver.com>
References: <20120824161330.GC27147@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 24 Aug 2012 12:13:31 -0400

> This batch of fixes is intended for 3.6...
> 
> Johannes Berg gives us a pair of iwlwifi fixes.  One corrects some
> improperly defined ifdefs that lead to crashes and BUG_ONs.  The other
> prevents attempts to read SRAM for devices that aren't actually started.
> 
> Julia Lawall provides an ipw2100 fix to properly set the return code
> from a function call before testing it! :-)
> 
> Thomas Huehn corrects the improper use of a constant related to a power
> setting in ath5k.
> 
> Thomas Pedersen offers a mac80211 fix to properly handle destination
> addresses of unicast frames passing though a mesh gate.
> 
> Vladimir Zapolskiy provides a brcmsmac fix to properly mark the
> interface state when the device goes down.

Pulled, thanks a lot John.
