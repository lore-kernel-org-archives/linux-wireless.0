Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45608 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0FWTpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 15:45:11 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1ORVsl-0004aP-1L
	for linux-wireless@vger.kernel.org; Wed, 23 Jun 2010 15:45:11 -0400
Received: from linville-t400.local (linville-t400.local [127.0.0.1])
	by linville-t400.local (8.14.4/8.14.3) with ESMTP id o5NJgqVP027231
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jun 2010 15:42:52 -0400
Received: (from linville@localhost)
	by linville-t400.local (8.14.4/8.14.4/Submit) id o5NJgqQe027229
	for linux-wireless@vger.kernel.org; Wed, 23 Jun 2010 15:42:52 -0400
Date: Wed, 23 Jun 2010 15:42:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-next-2.6 rebase 2010-06-23
Message-ID: <20100623194251.GG15205@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI...in order to avoid merging a patch series with build breakage, I'm
rebasing wireless-next-2.6.  The master-2010-06-21 tag is still valid,
but the master-2010-06-22 tag is no longer an ancestor of master.

If you have no idea what I mean, then feel free to ignore this
message. :-)  Most people should be using wireless-testing anyway.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
