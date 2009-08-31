Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38161 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752789AbZHaTeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 15:34:14 -0400
Message-ID: <4A9C25AE.9020109@gmx.de>
Date: Mon, 31 Aug 2009 21:34:06 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Chunkeey@web.de
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ar9170: added phy register initialisation from eeprom
 values
References: <1789900589@web.de>
In-Reply-To: <1789900589@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2009 11:53 AM, Chunkeey@web.de wrote:
> ...
> See Documentation/CodingStyle - Chapter 8
> 
> The preferred style for long (multi-line) comments is:
> /*
>  * look up a certain register in ar5416_phy_init[] and return the init. value
>  * for the band and bandwidth given. Return 0 if register address not found.
>  */
> ...

Thanks for the comments. I agree with all of them and will re-spin a patch.

> It's amazing how much **** you can _cut_ from the vendor driver.

Yes, at first sight it looks really complex but it isn't.

> BTW: does this patch help the 1-stage fw stability, or is it still broken?

Turned out I had a corrupt firmware file. After downloading from Luis' URL it works fine
with my WNDA3100. Guess I had an earlier version from before 2009/05/28 or firefox corrupted it during download.

What's your setup to get 80+ MBit/s throughput with the two-stage firmware?
I've used an 802.11g AP so far, but have access to an 802.11n dual-band AP now.
Guess I should use 5GHz as 2.4 is rather crowded here.
How can I put ar9170 into 802.11n/40MHz mode?

Regards,
Jörg.
