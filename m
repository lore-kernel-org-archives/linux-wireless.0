Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38251 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbbBXKdQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:33:16 -0500
Message-ID: <1424773990.2192.27.camel@sipsolutions.net> (sfid-20150224_113339_525209_1E7A4DA9)
Subject: Re: [PATCH 8/8] NFC: Add Intel FieldsPeak NFC solution driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Robert Dolca <robert.dolca@intel.com>
Cc: linux-nfc@ml01.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date: Tue, 24 Feb 2015 11:33:10 +0100
In-Reply-To: <1424772112-27399-9-git-send-email-robert.dolca@intel.com> (sfid-20150224_110328_126821_85458A24)
References: <1424772112-27399-1-git-send-email-robert.dolca@intel.com>
	 <1424772112-27399-9-git-send-email-robert.dolca@intel.com>
	 (sfid-20150224_110328_126821_85458A24)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have no idea about NFC, but 

> +config NFC_FDP
> +	tristate "Intel FDP NFC driver"
> +	depends on NFC_NCI
> +	select CRC_CCITT
> +	default n
> +	---help---
> +	  Intel FDP core driver.
> +	  This is a driver based on the NCI NFC kernel layers.
> +
> +	  To compile this driver as a module, choose m here. The module will
> +	  be called pn547.

this seems like a copy/paste error? Certainly it's called fdp?

johannes

