Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38199 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3EMOaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 10:30:08 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1UbtlP-0000dc-JE
	for linux-wireless@vger.kernel.org; Mon, 13 May 2013 10:30:07 -0400
Received: from linville-x1.hq.tuxdriver.com (localhost.localdomain [127.0.0.1])
	by linville-x1.hq.tuxdriver.com (8.14.6/8.14.6) with ESMTP id r4DERjZj030087
	for <linux-wireless@vger.kernel.org>; Mon, 13 May 2013 10:27:46 -0400
Received: (from linville@localhost)
	by linville-x1.hq.tuxdriver.com (8.14.6/8.14.6/Submit) id r4DERjlV030086
	for linux-wireless@vger.kernel.org; Mon, 13 May 2013 10:27:45 -0400
Date: Mon, 13 May 2013 10:27:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-testing rebased on 3.10-rc1
Message-ID: <20130513142744.GA30036@tuxdriver.com> (sfid-20130513_163024_725769_357870C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI...the wireless-testing tree has been rebased upon v3.10-rc1
as of this morning.  I also pulled the pending fixes from
the wireless-tree on top of it, as well as the venerable old
localversion-wireless patch we all love.  The head commit is
de71a9b7484a7fb6a91303370a20a55f3069eb96.

It may be a few days before I resume merging into wireless-next.
I will be traveling and I want to give Dave M. a chance to settle-out
his trees.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
