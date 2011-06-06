Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:53838 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab1FFU0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 16:26:54 -0400
Date: Mon, 06 Jun 2011 13:25:49 -0700 (PDT)
Message-Id: <20110606.132549.1074295213687787615.davem@davemloft.net> (sfid-20110606_222716_031075_802B5BE0)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-06-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110606190427.GH2604@tuxdriver.com>
References: <20110606190427.GH2604@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 6 Jun 2011 15:04:27 -0400

> Here are a few more fixes intended for 3.0 -- a libertas fix for a
> regression related to spurious interrupts, an ath5k fix to disable
> "fast" channel switching (since it caused a number of devices to
> regress in performance), an ssb fix for a regression that was applying
> PCIe workarounds to PCI devices (causing a machine check), an fix for an
> iwlagn locking regression, and a mac80211 fix for a device-naming
> regression.
> 
> Please let me know if there are problems!

Pulled, thanks John.
