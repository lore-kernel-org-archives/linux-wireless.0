Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:59796 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270AbYL0CFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 21:05:35 -0500
Message-ID: <49558D65.1060008@lwfinger.net> (sfid-20081227_030550_133482_37D2B2A2)
Date: Fri, 26 Dec 2008 20:05:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43/ssb: Add SPROM8 extraction and LP-PHY detection
References: <200812250039.28824.mb@bu3sch.de>	 (sfid-20081225_004044_707129_A1975627) <1230162724.3162.3.camel@johannes>
In-Reply-To: <1230162724.3162.3.camel@johannes>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2008-12-25 at 00:39 +0100, Michael Buesch wrote:
>> This adds detection code for the LP-PHY and SPROM
>> extraction code for version 8, which is needed by the LP-PHY and
>> newer N-PHY.
> 
> I still get mac address ff:ff:ff:ff:ff:ff with this, but it might just
> be that we need to use a different address or something, will double
> check. We can fix that, so don't take this as a nack, the patch lays the
> foundation, and the devices aren't supported anyway.

Johannes,

Could you extract the SPROM contents from /sys and send me the data? I'm nearly
completed with a pretty extensive rewrite of ssb-sprom, and I would like an
additional sample of a rev 8 device.

Thanks,

Larry
