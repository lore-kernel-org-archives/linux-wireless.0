Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:48793 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3LVDf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Dec 2013 22:35:26 -0500
Date: Sat, 21 Dec 2013 22:35:24 -0500 (EST)
Message-Id: <20131221.223524.32283555347774572.davem@davemloft.net> (sfid-20131222_043550_826233_E11EC49C)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-12-20
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131220210132.GB15392@tuxdriver.com>
References: <20131220210132.GB15392@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 20 Dec 2013 16:01:32 -0500

> Please consider pulling this batch of fixes for the 3.13 stream...
> 
> For the mac80211 bits, Johannes says:
> 
> "Here's a fix for another potential radiotap parser buffer overrun thanks
> to Evan Huus, and a fix for a cfg80211 warning in a certain corner case
> (reconnecting to the same BSS)."
> 
> For the bluetooth bits, Gustavo says:
> 
> "Two patches in this pull request. An important fix from Marcel in the
> permission check for HCI User Channels, there was a extra check for
> CAP_NET_RAW, and it was now removed. These channels should only require
> CAP_NET_ADMIN. The other patch is a device id addition."
> 
> On top of that...
> 
> Sujith Manoharan provides a workaround for a hardware problem that
> can result in lost interrupts.
> 
> Larry Finger fixes an oops when unloading the rtlwifi driver (Red
> Hat bug 852761).
> 
> Mathy Vanhoef fixes a somewhat minor MAC address privacy issue
> (CVE-2013-4579).

Pulled, thanks John.
