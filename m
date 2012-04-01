Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:44345 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab2DAULi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 16:11:38 -0400
Date: Sun, 01 Apr 2012 16:10:31 -0400 (EDT)
Message-Id: <20120401.161031.886756026206260043.davem@davemloft.net> (sfid-20120401_221218_107013_7FB94228)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-03-30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120330175533.GC8273@tuxdriver.com>
References: <20120330175533.GC8273@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 30 Mar 2012 13:55:34 -0400

> I have a few more small fixes, hopefully still in time for 3.4-rc1...
> 
> Rajkukmar provides us with a one-line timestamp correction related to
> scanning in mac80211.  Sujith gives us a small fixup for a regression
> in the handling of HT capability bits for ath9k.  Stanislav Yakovlev
> is stepping-up as maintainer for the ipw2x00 drivers, so we'll add
> him to MAINTAINERS.  Stanislav also gives us a fix for a thinko
> that registers the wrong band information for ipw2200 and 802.11a.
> Finally, Santosh Nayak adds some simple error checking to orinoco to
> avoid some potential NULL pointer dereferences.

Pulled, thanks John.
