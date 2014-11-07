Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:33514 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKGDQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 22:16:00 -0500
Date: Thu, 06 Nov 2014 22:15:57 -0500 (EST)
Message-Id: <20141106.221557.165590048048299292.davem@davemloft.net> (sfid-20141107_041623_569233_E32AF823)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-11-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141106205231.GE4440@tuxdriver.com>
References: <20141106205231.GE4440@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 6 Nov 2014 15:52:31 -0500

> Please pull this batch of fixes intended for the 3.18 stream...
> 
> For the mac80211 bits, Johannes says:
> 
> "This contains another small set of fixes for 3.18, these are all
> over the place and most of the bugs are old, one even dates back
> to the original mac80211 we merged into the kernel."
> 
> For the iwlwifi bits, Emmanuel says:
> 
> "I fix here two issues that are related to the firmware
> loading flow. A user reported that he couldn't load the
> driver because the rfkill line was pulled up while we
> were running the calibrations. This was happening while
> booting the system: systemd was restoring the "disable
> wifi settings" and that raised an RFKILL interrupt during
> the calibration. Our driver didn't handle that properly
> and this is now fixed."
> 
> Please let me know if there are problems!

Pulled, thanks John.
