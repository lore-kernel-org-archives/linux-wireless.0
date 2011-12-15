Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:45122 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759674Ab1LOW4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 17:56:04 -0500
Date: Thu, 15 Dec 2011 17:54:57 -0500 (EST)
Message-Id: <20111215.175457.1993211580046983211.davem@davemloft.net> (sfid-20111215_235627_304919_392FA394)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-12-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111215191523.GA2561@tuxdriver.com>
References: <20111215191523.GA2561@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 15 Dec 2011 14:15:24 -0500

> Here are a few more fixes intended for the 3.2 release.  They are
> all small and narrowly focused.
> 
> First is a one liner fix for a signedness problem in NFC that could
> lead to an incorrect return code being propogated.  Next are two
> iwlwifi regression fixes that received some recent attention on the
> linux-wireless mailing list.  A third iwlwifi fix corrects a sequence
> numbering error, which can cause a lot of bad behaviour in the wireless
> network.  The ath9k fix corrects a potential for an array underrun.
> Finally, the mwifiex fix corrects a double list deletion.
> 
> Please let me know if there are problems!

Pulled, thanks John.
