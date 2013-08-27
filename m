Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:59306 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3H0Tzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 15:55:54 -0400
Date: Tue, 27 Aug 2013 15:55:52 -0400 (EDT)
Message-Id: <20130827.155552.747451190932124237.davem@davemloft.net> (sfid-20130827_215618_385754_221194F9)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-08-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130823162044.GD15114@tuxdriver.com>
References: <20130823162044.GD15114@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 23 Aug 2013 12:20:44 -0400

> This is one more set of fixes intended for the 3.11 stream...
> 
> For the mac80211 bits, Johannes says:
> 
> "I have three more patches for the 3.11 stream: Felix's fix for the
> fairly visible brcmsmac crash, a fix from Simon for an IBSS join bug I
> found and a fix for a channel context bug in IBSS I'd introduced."
> 
> Along with those...
> 
> Sujith Manoharan makes a minor change to not use a PLL hang workaroun
> for AR9550.  This one-liner fixes a couple of bugs reported in the Red Hat
> bugzilla.
> 
> Helmut Schaa addresses an ath9k_htc bug that mangles frame headers
> during Tx.  This fix is small, tested by the bug reported and isolated
> to ath9k_htc.
> 
> Stanislaw Gruszka reverts a recent iwl4965 change that broke rfkill
> notification to user space.
> 
> Please let me know if there are problems!

Pulled, thanks John.
