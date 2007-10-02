Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serenity.mcc.ac.uk ([130.88.200.93]:57485 "EHLO
	serenity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbXJBQd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 12:33:59 -0400
Message-ID: <470272CE.60405@gentoo.org> (sfid-20071002_173438_911320_99789621)
Date: Tue, 02 Oct 2007 17:33:18 +0100
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: What happened with z1211?
References: <200710021147.55506.mb@bu3sch.de>
In-Reply-To: <200710021147.55506.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Hi John,
> 
> What happened with the z1211 driver in wireless-2.6?
> It's not there anymore. There's only the old zd1211rw
> and zd1211rw-mac80211 stuff. Did you rename it again?

We aren't going to rename the driver, we're going to directly port 
drivers/net/wireless/zd1211rw to mac80211 when we're ready. John has put 
it back as zd1211rw-mac80211 for now to allow development to continue. 
Don't use the zd1211rw-mac80211 branch though (it won't compile), 
develop against 'everything' as usual.

Thanks,
Daniel

