Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:36643 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab1EKXSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 19:18:14 -0400
Date: Wed, 11 May 2011 19:16:50 -0400 (EDT)
Message-Id: <20110511.191650.1128601216324052082.davem@davemloft.net> (sfid-20110512_011839_865234_82CBE8CB)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-05-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110511192742.GG2490@tuxdriver.com>
References: <20110511192742.GG2490@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 11 May 2011 15:27:42 -0400

> Here are a few more late-breakers that I would like to see in 2.6.39.
> The one from Luca fixes a problem that can cause devices to be unable
> to (re-)associate after a disconnect.  The ath9k fix from Mohammed
> fixes a WARNING, the one from Paul fixes a locking issue that can
> lead to data corruption, and the one from Stanislaw fixes a crash
> documented in bug 34452.  All are small and all but one are contained
> within their respective drivers.
> 
> Please let me know if there are problems!

Pulled, but I can't guarentee that this will make it to 2.6.39-final
at this point.

Thanks!
