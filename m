Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:39483 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3D3EMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 00:12:06 -0400
Date: Tue, 30 Apr 2013 00:12:01 -0400 (EDT)
Message-Id: <20130430.001201.1764845606650321215.davem@davemloft.net> (sfid-20130430_061239_753461_563BA4E1)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2013-04-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130429194550.GC4590@tuxdriver.com>
References: <20130429194550.GC4590@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 29 Apr 2013 15:45:51 -0400

> For the Bluetooth bits, Gustavo says:
> 
> "A few more patches intended for 3.10, the most important one is the support in
> btusb for fw loading for the Intel Bluetooth device. Other than that we have
> only fixes and clean ups."
> 
> For the iwlwifi bits, Johannes says:
> 
> "Here are a few more changes for the 3.10 stream, some bugfixes,
> adjustments to some powersave parameters and a new device ID."
> 
> For the NFC bits, Samuel says:
> 
> "This pull request includes Marcel's Kconfig dependency fix on top of the LLCP
> code move to net/nfc."
> 
> On top of that...Yogesh Ashok Powar provides a few PCI-related mwifiex
> updates, Hauke Mehrtens provides a small ssb feature for spurious
> tone avoidance on a specific chip, and Larry Finger provides a small
> rtlwifi fix related to avoiding false detection of AP loss.

Pulled, thanks John.
