Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:47775 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaIXTBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 15:01:32 -0400
Date: Wed, 24 Sep 2014 15:01:29 -0400 (EDT)
Message-Id: <20140924.150129.1615102185939385229.davem@davemloft.net> (sfid-20140924_210151_967742_A9D8B4F9)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-09-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140923150002.GH23806@tuxdriver.com>
References: <20140923150002.GH23806@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 23 Sep 2014 11:00:02 -0400

> Please consider pulling this one last batch of fixes intended for the 3.17 stream!
> 
> For the NFC bits, Samuel says:
> 
> "Hopefully not too late for a handful of NFC fixes:
> 
> - 2 potential build failures for ST21NFCA and ST21NFCB, triggered by a
>   depmod dependenyc cycle.
> - One potential buffer overflow in the microread driver."
> 
> On top of that...
> 
> Emil Goode provides a fix for a brcmfmac off-by-one regression which
> was introduced in the 3.17 cycle.
> 
> Loic Poulain fixes a polarity mismatch for a variable assignment
> inside of rfkill-gpio.
> 
> Wojciech Dubowik prevents a NULL pointer dereference in ath9k.
> 
> Please let me know if there are problems!

Pulled, thanks John.
