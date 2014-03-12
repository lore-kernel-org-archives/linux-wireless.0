Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:33064 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaCLCuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 22:50:25 -0400
Date: Tue, 11 Mar 2014 22:50:23 -0400 (EDT)
Message-Id: <20140311.225023.1953610775705849306.davem@davemloft.net> (sfid-20140312_035031_971966_CDB92A28)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-03-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140310190101.GB25703@tuxdriver.com>
References: <20140310190101.GB25703@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 10 Mar 2014 15:01:02 -0400

> For the mac80211 bits, Johannes says:
> 
> "This time, I have a number of small fixes and improvements, and those
> are fairly straight-forward. More interesting changes come from Luca
> with some preparations for the CSA work, mostly around interface/channel
> combinations checking. One other possibly interesting change is a small
> one by myself to add NAPI support back to mac80211, which can help
> improve TCP behaviour through GRO."
> 
> For the Bluetooth bits, Gustavo says:
> 
> "This is our first pull request for 3.15, the main feature here is the addition of
> the privacy feature for low energy devices. Other than that we have a bunch of small
> improvements, fixes, and clean ups all over the tree."
> 
> And...
> 
> "Another pull request to 3.15. Here we have the second part of the LE private
> feature, the LE auto-connect feature and improvements to the power off
> procedures. The rest are small improvements, clean up, and fixes."
> 
> For the iwlwifi bits, Emmanuel says:
> 
> "I have here a whole bunch of various things. Trivial cleanups,
> debugfs handlers and new stuff for the new generation of devices
> along with new capabilities for monitor mode. We also have support
> for power save for dual interface mode, but that is not supported by
> the firmware currently available."
> 
> And for the Atheros bits, Kalle says:
> 
> "For ath10k Alexander did some cleanup to PCI error cases and switched
> ath10k to use pci_enable_msi_range(). Michal implemented AP CSA support
> and sta_rc_update() operation. I enabled firmware "STA quick kickout"
> functionality for faster detection of disappeared clients.
> 
> Also there are lots of small fixes to everywhere from various people."
> 
> I pulled the wireless tree to avoid some merge conflicts, and I
> reverted the staging patch that I had mistakenly merged previously.
> Along with that, mwifiex, brcmfmac, wil6210, ath9k, and a few other
> drivers get their usual round of updates.  Also notable is the addition
> of yet another driver in the rtlwifi family.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
