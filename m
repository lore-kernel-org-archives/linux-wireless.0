Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41889 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZA3Ups (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 15:45:48 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1LT0FH-0007zb-5j
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2009 15:45:47 -0500
Received: from linville-t43.local (linville-t43.local [127.0.0.1])
	by linville-t43.local (8.14.2/8.14.2) with ESMTP id n0UKirGR013660
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 15:44:53 -0500
Received: (from linville@localhost)
	by linville-t43.local (8.14.2/8.14.2/Submit) id n0UKirNO013659
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2009 15:44:53 -0500
Date: Fri, 30 Jan 2009 15:44:52 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-regdb updated 2009-01-30
Message-ID: <20090130204452.GG3485@tuxdriver.com> (sfid-20090130_214551_657699_6488A8C5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have pushed an update to the wireless-regdb database here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git

The changes include a new man page for regulatory.bin, some sample
packages for .deb and .rpm generation, and an actual database change
to correct a mistake in the Japan portion of the database.

Enjoy!	Let me know if there are problems...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
