Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:54262 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbZFAWWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 18:22:23 -0400
Subject: ar9170 vs otus advice?
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 01 Jun 2009 17:07:00 -0500
Message-Id: <1243894020.1559.22.camel@bigfoot-m4a75t>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > mac80211 drivers:
> > 
> > agnx	-> http://git.sipsolutions.net/agnx.git
> > at76_usb	-> replacement already in kernel.org code at drivers/net/wireless/at76c50x-usb.[ch]
> > otus	-> replacement already in kernel.org code at drivers/net/wireless/ar9170/
> 
> Thanks for the summary.
> 
> Note, whenever a "real" wireless driver goes into the tree that
> obsoletes any of the staging drivers, please let me know and I'll
> instantly remove it.
> 
> Right now the otus code is staying because the ar9170 developers want it
> to.


So, I'm trying to understand the current state of the ar9170 and otus
drivers so that I may know where to direction some effort.  I'd like to
get an WN111v2 running with 11n support, and am willing to start with
either the ar9170 or otus drivers as needed.  But I've not been following
along in too much detail so far.

Advice on where I should start, what's working, what's not working,
what needs help, etc?  And should I start with one of the linville Git
trees?  Or wireless-everything?

Thanks,
jdl


