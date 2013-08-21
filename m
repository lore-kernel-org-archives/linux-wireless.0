Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49346 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3HUA0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 20:26:20 -0400
Date: Tue, 20 Aug 2013 17:26:19 -0700 (PDT)
Message-Id: <20130820.172619.2224001430937589898.davem@davemloft.net> (sfid-20130821_022639_775812_71E062D7)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-08-19
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130819185940.GE30753@tuxdriver.com>
References: <20130819185940.GE30753@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 19 Aug 2013 14:59:40 -0400

> This is a batch of fixes intended for the 3.11 stream...
> 
> Regarding the iwlwifi bits, Johannes says:
> 
> "We revert an rfkill bugfix that unfortunately caused more bugs, shuffle
> some code to avoid touching the PCIe device before it's enabled and
> disconnect if firmware fails to do our bidding. I also have Stanislaw's
> fix to not crash in some channel switch scenarios."
> 
> As for the mac80211 bits, Johannes says:
> 
> "This time, I have one fix from Dan Carpenter for users of
> nl80211hdr_put(), and one fix from myself fixing a regression with the
> libertas driver."
> 
> Along with the above...
> 
> Dan Carpenter fixes some incorrectly placed "address of" operators
> in hostap that caused copying of junk data.
> 
> Jussi Kivilinna corrects zd1201 to use an allocated buffer rather
> than the stack for a URB operation.
> 
> Please let me know if there are problems!

Pulled, thanks John.
