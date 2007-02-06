Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:46028 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965575AbXBFW3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 17:29:17 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HEYnI-0004PV-1Y
	for linux-wireless@vger.kernel.org; Tue, 06 Feb 2007 17:28:08 -0500
Subject: Re: RFT bcm43xx: Really _GOOD_ news
From: Pavel Roskin <proski@gnu.org>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200702061637.31756.gene.heskett@verizon.net>
References: <45C8E64B.1050605@lwfinger.net>
	 <200702061637.31756.gene.heskett@verizon.net>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 17:29:13 -0500
Message-Id: <1170800953.2613.17.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-02-06 at 16:37 -0500, Gene Heskett wrote:

> That's great Larry.  Now how long does it take to get this into a
> distro's 
> update kernel queue?  Or do I have to build a kernel for my lappy, 
> currently on FC5?

Gene, I think it would be better for all of us if we don't bother Larry
with such questions and let him discover the secrets of the 802.11g
rates :)

I think that patch has a good chance to get into Fedora 7 from the
beginning.  We may see it in Fedora Core 6 if it goes to Linux 2.6.20
and this patch goes to the 2.6.20.x branch before that.

I think the best we can do now would be to test the driver and report
the results.  This would speed up the process of getting the patch to
the kernel.  Yes, that means recompiling the kernel.

-- 
Regards,
Pavel Roskin

