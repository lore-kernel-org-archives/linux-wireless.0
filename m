Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54102 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZANQar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 11:30:47 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1LN8dh-0006kK-G8
	for linux-wireless@vger.kernel.org; Wed, 14 Jan 2009 11:30:45 -0500
Received: from linville-t43.local (linville-t43.local [127.0.0.1])
	by linville-t43.local (8.14.2/8.14.2) with ESMTP id n0EGMpiS008445
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 11:22:51 -0500
Received: (from linville@localhost)
	by linville-t43.local (8.14.2/8.14.2/Submit) id n0EGMpi7008444
	for linux-wireless@vger.kernel.org; Wed, 14 Jan 2009 11:22:51 -0500
Date: Wed, 14 Jan 2009 11:22:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-regdb updated 2009-01-14
Message-ID: <20090114162250.GC3854@tuxdriver.com> (sfid-20090114_173051_259617_B95BD0EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI...wireless-regdb.git has been updated with the recent patches
from Michael, Luis, and Pavel.  In particular the Makefile is much
better than I had previously left it. :-)

It is about time (or past time) that we start pushing distributions to
pick-up CRDA and either their own version of wireless-regdb or just
pull the version I am publishing.  I think our wireless regulatory
compliance mechanisms are a lot more flexible than what other systems
are offering -- it is time to get it into the hands of users and get
userland apps (e.g. NetworkManager) to take advantage of it.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
