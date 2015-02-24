Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20790 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbbBXKqy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:46:54 -0500
Date: Tue, 24 Feb 2015 12:46:49 +0200
From: Robert Dolca <robert.dolca@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-nfc@ml01.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 8/8] NFC: Add Intel FieldsPeak NFC solution driver
Message-ID: <20150224104648.GA28148@rdolca-desk.ger.corp.intel.com> (sfid-20150224_114726_991668_6AD0E1AF)
References: <1424772112-27399-1-git-send-email-robert.dolca@intel.com>
 <1424772112-27399-9-git-send-email-robert.dolca@intel.com>
 <1424773990.2192.27.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424773990.2192.27.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2015 at 11:33:10AM +0100, Johannes Berg wrote:
> > +config NFC_FDP
> > +	tristate "Intel FDP NFC driver"
> > +	depends on NFC_NCI
> > +	select CRC_CCITT
> > +	default n
> > +	---help---
> > +	  Intel FDP core driver.
> > +	  This is a driver based on the NCI NFC kernel layers.
> > +
> > +	  To compile this driver as a module, choose m here. The module will
> > +	  be called pn547.
>
> this seems like a copy/paste error? Certainly it's called fdp?

You are right. It should be FDP instead of pn547.

I will also rename the menu entry name from "Intel FDP NFC driver" to
"Intel FieldsPeak (FDP) NFC driver" to be more clear what FDP means.

Thanks,
Robert
