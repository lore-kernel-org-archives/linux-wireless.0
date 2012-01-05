Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:33903 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab2AETXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 14:23:15 -0500
Date: Thu, 05 Jan 2012 14:21:52 -0500 (EST)
Message-Id: <20120105.142152.1306829639610242754.davem@davemloft.net> (sfid-20120105_202320_468348_B2D0F150)
To: bhutchings@solarflare.com
Cc: festevam@gmail.com, Larry.Finger@lwfinger.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	gwingerde@gmail.com, linville@tuxdriver.com,
	fabio.estevam@freescale.com
Subject: Re: [PATCH v2] drivers: net: Fix dependency for EEPROM_93CX6
From: David Miller <davem@davemloft.net>
In-Reply-To: <1325791078.3764.30.camel@bwh-desktop>
References: <CAOMZO5AuZ_MHW3C1uNK7PyRz=XRHXhn2pvKCwk7iXLDd0YkDOQ@mail.gmail.com>
	<CAOMZO5DTDpp8+9FOjPXGFQtQPg7Pv5qfAwFO3UC6AUdEDgpHYg@mail.gmail.com>
	<1325791078.3764.30.camel@bwh-desktop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Thu, 5 Jan 2012 19:17:58 +0000

> Right, you'll have to delete all dependencies on MISC_DEVICES.  Maybe
> remove it from defconfigs as well, though I'm not sure whether it's
> normal to do that at the same time.

defconfigs are usually left to the arch maintainers to update.
