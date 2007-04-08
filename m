Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [83.246.81.11] ([83.246.81.11]:47464 "EHLO slim.vantronix.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbXDHSdI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 14:33:08 -0400
Date: Sun, 8 Apr 2007 20:29:46 +0200
From: Reyk Floeter <reyk@openbsd.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Reyk Floeter <reyk@openbsd.org>, proski@gnu.org,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Marcus Glocker <mglocker@openbsd.org>,
	Theo de Raadt <deraadt@theos.com>
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Message-ID: <20070408182946.GB18323@slim.vantronix.net>
References: <200704041945.21447.mb@bu3sch.de> <20070408132743.GA12836@slim.vantronix.net> <200704081550.22579.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200704081550.22579.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 08, 2007 at 03:50:22PM +0200, Michael Buesch wrote:
> On Sunday 08 April 2007 15:27, Reyk Floeter wrote:
> > Instead of attacking developers of non-GPL free software, you should
> > point your lawyers into another direction to think about ways to
> > include GPL-compatible BSD/ISC code in the Linux kernel without the
> > need for relicensing it. Talk to the Linux maintainers to change this
> > stupid Dual GPL/* policy.
> > 
> > It is your choice, you can also rewrite the "OpenHAL" and take my code
> > as a reference. The copyright does not protect the "idea" of the
> > implementation or the algorithms. Feel free to read my code, interpret
> > it and express it differently.
> 
> Excuse my ignorance, please, but I don't see where the real problem is.
> What's the problem with taking openHAL and putting it into the yet to
> be written GPLed linux atheros driver, while preserving your copyright
> notices. I don't see how this could violate the BSD license.
> 
> Such stuff is going on day by day. One good example of BSD code put into
> code with another license was MS with the NT TCP stack. At least of my
> knowledge that was the FreeBSD stack, until they rewrote it.
> 
> So, what's the problem, really? Create a derivative work, where
> the original openHAL parts are still de-facto BSD licensed, but the rest
> is GPLed.
> 

I expected that you know the Linux kernel license policies. But you
got it, it doesn't make sense.

reyk
