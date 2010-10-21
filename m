Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60293 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0JUSAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 14:00:25 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1P8zQv-0006Tz-HC
	for linux-wireless@vger.kernel.org; Thu, 21 Oct 2010 14:00:09 -0400
Received: from linville-8530p.local (localhost.localdomain [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id o9LHvhTj009103
	for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 13:57:45 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id o9LHvgIP009074
	for linux-wireless@vger.kernel.org; Thu, 21 Oct 2010 13:57:42 -0400
Date: Thu, 21 Oct 2010 13:57:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless GIT state...
Message-ID: <20101021175741.GC6430@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hopefully you saw davem's similarly titled post...

I don't see much in the -next patches I've had in wireless-testing
over the last few days that is a big deal for 2.6.37.  Those that do
seem important are fixes that can still go anyway.

Stephen usually asks not to have anything in the trees during the
merge window that isn't intended for Linus.  So I'm going to reset
wireless-next-2.6 back to where it was for the last pull done by davem.
I will also remove those patches from wireless-testing just to avoid
being out of sync -- the fixes will be back soon, and the others will
be back after the close of the merge window.  I will be merging the
fixes and sending them to davem during the window -- feel free to
identify anything you think I might miss.

Also, as I have mentioned previously, I intend to start rebasing
wireless-testing after each merge window.  As it stands today, the
history is too much of a mess to be useful for bisection anyway.  I
hope everyone can handle a once-per-release rebase of wireless-testing.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
