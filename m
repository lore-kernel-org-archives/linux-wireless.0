Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7555 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbYFKTrs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 15:47:48 -0400
Subject: Re: Open source driver with binary HAL for BCM4313 from Broadcom
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Tim Gardner <tim.gardner@canonical.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200806112047.00854.mb@bu3sch.de>
References: <48500F14.8070300@canonical.com>
	 <200806112047.00854.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 15:47:46 -0400
Message-Id: <1213213666.19106.12.camel@dv> (sfid-20080611_214751_070343_53451118)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-11 at 20:47 +0200, Michael Buesch wrote:
> On Wednesday 11 June 2008 19:44:52 Tim Gardner wrote:
> > John,
> > 
> > Here is the URL to Broadcom's web site advertising their open source
> > driver with support for the BCM4313.
> > 
> > http://www.broadcom.com/support/802.11/linux_sta.php
> > 
> > rtg
> 
> <quote>
> Make sure that you download the appropriate tar because the hybrid binary
> file must be of the appropriate architecture type. The hybrid binary file
> is agnostic to the specific version of the Linux kernel because it is
> designed to perform all interactions with the operating system through
> operating-system-specific files...
> </quote>

Sure, they are trying to do the MadWifi thing, but it's too late since a
good free driver exists already, even if it doesn't support that
particular chip.

Still, the glue code and the headers are under GPL.  It may be useful
for reverse engineering efforts.

Perhaps the non-free object files could be used to extract firmware from
them.  But the license won't allow distribution of that firmware, if I
understand correctly.

What Broadcom could easily do is to release the firmware under a license
that would allow free distribution.  This way, the firmware would be on
installation CDs of the popular distributions, and there would be no
need to install b43-fwcutter, get the firmware (that's a challenge in
absence of a wired network), extract the firmware and install it into
the right directory.  That would make Broadcom cards make out-of-box,
and ultimately make them more popular.

Instead, Broadcom tries to control the code its users are running.  I
don't think it's going to work well.  But to be fair to them, at least
they don't pretend that Linux doesn't exit.

-- 
Regards,
Pavel Roskin
