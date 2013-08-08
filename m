Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36160 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966588Ab3HHVHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 17:07:32 -0400
Date: Thu, 08 Aug 2013 14:12:41 -0700 (PDT)
Message-Id: <20130808.141241.2150105195238423513.davem@davemloft.net> (sfid-20130808_230752_488050_725625DA)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-08-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130808172940.GC30925@tuxdriver.com>
References: <20130808172940.GC30925@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 8 Aug 2013 13:29:40 -0400

> This is a batch of fixes intended for the 3.11 queue...
> 
> Regarding the mac80211 (and related) bits, Johannes says:
> 
> "I have a fix from Chris for an infinite loop along with fixes from
> myself to prevent it entering the loop to start with (continue using
> disabled channels, many thanks to Chris for his debug/test help) and a
> workaround for broken APs that advertise a bad HT primary channel in
> their beacons. Additionally, a fix for another attrbuf race in mac80211
> and a fix to clean up properly while P2P GO interfaces go down."
> 
> Along with that...
> 
> Solomon Peachy corrects a range check in cw1200 that would lead to
> a BUG_ON when starting AP mode.
> 
> Stanislaw Gruszka provides an iwl4965 patch to power-up the device
> earlier (avoiding microcode errors), and another iwl4965 fix that
> resets the firmware after turning rfkill off (resolving a bug in the
> Red Hat Bugzilla).
> 
> Please let me know if there are problems!

Pulled, thanks John.
