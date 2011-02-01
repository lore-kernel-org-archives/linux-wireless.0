Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38207 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1BARPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 12:15:17 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1PkJoy-0000yd-2a
	for linux-wireless@vger.kernel.org; Tue, 01 Feb 2011 12:15:16 -0500
Received: from linville-8530p.local (localhost.localdomain [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id p11H5FZs009843
	for <linux-wireless@vger.kernel.org>; Tue, 1 Feb 2011 12:05:15 -0500
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id p11H5EPJ009841
	for linux-wireless@vger.kernel.org; Tue, 1 Feb 2011 12:05:14 -0500
Date: Tue, 1 Feb 2011 12:05:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: FYI -- wireless-2.6 and wireless-next-2.6 rebased
Message-ID: <20110201170514.GB2560@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I rebased wireless-2.6 to remove a "Cc: stable@kernel.org" that I had
erroneously added to a commit message.  Since wireless-next-2.6 had
already pulled that commit (as part of a pull to resolve a conflict),
it has been rebased as well.

The changed commit only happened yesterday, so if you haven't pulled
in the last 24 hours then you should be fine.  Likewise, most people
should only be using wireless-testing anyway and so they should be
fine as well.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
