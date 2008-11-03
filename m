Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:32537 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbYKCTmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 14:42:52 -0500
Date: Mon, 3 Nov 2008 11:42:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org
Subject: print_ssid undefined (linux-next 20081103)
Message-Id: <20081103114222.b257f711.randy.dunlap@oracle.com> (sfid-20081103_204257_052396_C3A3F03F)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm seeing a few instances of

ERROR: "print_ssid" [drivers/net/wireless/ipw2100.ko] undefined!

with ipw2100 & ipw2200 in today's linux-next (20081103).

These configs have
# CONFIG_WIRELESS is not set
CONFIG_WIRELESS_EXT=y

In looking into this more, I see that the wireless drivers can be enabled
& built even when CONFIG_WIRELESS=n.  Is this the expected behavior?
Seems a bit odd.

Thanks,
---
~Randy
