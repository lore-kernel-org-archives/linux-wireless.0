Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from root-server.richard-scherping.de ([217.160.107.144]:52437 "EHLO
	p15125984.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYBLTbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 14:31:53 -0500
Message-ID: <47B1F422.4060501@scherping.de> (sfid-20080212_193157_873958_ABCF9113)
Date: Tue, 12 Feb 2008 20:31:46 +0100
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello list!

Sorry for this slightly off-topic post (as I have not tried the latest wirless-dev git version)...

When trying to set up an ad-hoc interface on iwl4965 (version 1.2.23 according to modinfo) on recently released kernel 2.6.25-rc1 it seems to work at first glance (accepts setting of channel and essid, starts beaconing and receives frames just fine) but the TX part does not work at all. Frames are shown in "tcpdump -i wlan0" but never make it into the air (checked with dedicated machine equipped with an Atheros card running in monitor mode).
With 2.6.24 (iwl4965 version 1.1.17) everything worked fine. System is Debian Lenny amd64 on a Thinkpad T61p.

Unfortunately I do not have the time to debug this intensively, so any hints what to check first are welcome! Did something with the last big API change in mac80211 went wrong?

Richard
