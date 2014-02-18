Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36288 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaBRV6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 16:58:31 -0500
Date: Tue, 18 Feb 2014 16:58:28 -0500 (EST)
Message-Id: <20140218.165828.242891846729845555.davem@davemloft.net> (sfid-20140218_225851_824706_0D9430A7)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-02-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140217223921.GA29923@tuxdriver.com>
References: <20140217223921.GA29923@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 17 Feb 2014 17:39:21 -0500

> Please pull this batch of fixes intended for the 3.14 stream...
> 
> For the iwlwifi one, Emmanuel says:
> 
> "As explicitly written in the commit message, we prefer to disable Tx
> AMPDU on NICs supported by iwldvm. This feature gives a big boost in
> Tx performance, but the firmware is buggy and we can't rely on it.
> Our hope is that most of the users out there want wifi to surf on
> the web which means that they care more for Rx traffic than for Tx.
> People who want to enable it can do so with the help of a module
> parameter."
> 
> On top of that...
> 
> Dan Carpenter fixes a typo/thinko in ath5k.
> 
> Olivier Langlois fixes a couple of rtlwifi issues, one which leaves
> IRQs disabled too long (causing a variety of problems elsewhere),
> and one which fixes an incorrect return code when failing to enable
> the NIC.
> 
> Russell King fixes a NULL pointer dereference in hostap.
> 
> Stanislaw Gruszka fixes a DMA coherence issue in the rtl8187 driver.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
