Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:40346 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982AbXGFGwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 02:52:13 -0400
Message-ID: <468DE699.9040708@warmcat.com>
Date: Fri, 06 Jul 2007 07:52:09 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Arrested Development
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

I have a couple of outstanding patches that haven't gotten where they
are going (there was a third one to do with bcm43xx radiotap frequency
reporting, but that turned out to be more complex and my patch only
solved it for some firmwares, so we can forget about my patch if not the
problem).

First is the radiotap set that seems to be generally approved of now in
try #13 form.

http://www.spinics.net/lists/linux-wireless/msg03053.html

But it doesn't get elevated to wireless-git, I know because I check the
web interface for it every day like a kid waiting for Christmas.  Is
there something more I should be doing, or is it somehow waiting for a
ripe moment in the release cycle (even to go in wireless-dev?)

Second is a small patch for zd1211rw-mac80211 that fixes rate reporting
on radiotap rx, last sent here 11 June.

http://www.spinics.net/lists/linux-wireless/msg02897.html

This did not receive any comment, despite it should be simple to verify
it is currently broken and that this small patch fixes it, and I see
other small patches acknowledged and accepted there in the meanwhile.
Again, is there something more or different I should be doing?

-Andy
