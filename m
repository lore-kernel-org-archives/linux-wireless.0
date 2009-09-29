Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51857 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbZI2VAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 17:00:53 -0400
Date: Tue, 29 Sep 2009 17:00:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [rfkill PATCH] default install to $(PREFIX)/sbin
Message-ID: <20090929210001.GG2678@tuxdriver.com>
References: <1254246097-4490-1-git-send-email-linville@tuxdriver.com> <1254256477.30589.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254256477.30589.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2009 at 10:34:37PM +0200, Johannes Berg wrote:
> On Tue, 2009-09-29 at 13:41 -0400, John W. Linville wrote:
> > The rfkill utility isn't generally useful to normal users, so move it to
> > /sbin with other system management executables.
> 
> Seems to me that it's kinda useful, it should be possible for most users
> to use the event and query interface if the /dev/rfkill permissions are
> set up correctly.

Sure, but (just like ip, ifconfig, or iwconfig) nothing stops people
from using them in /sbin or /usr/sbin.  It is just a convention for
tools that are more for system management than for day-to-day use.

Hopefully most people will stick with NM or whatever and may stay
completely unaware of the rfkill utility. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
