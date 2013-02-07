Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60340 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab3BGW0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 17:26:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1U3Zvv-00007W-RW
	for linux-wireless@vger.kernel.org; Thu, 07 Feb 2013 23:27:08 +0100
Received: from pool-98-113-39-171.nycmny.fios.verizon.net ([98.113.39.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 23:27:07 +0100
Received: from erappleman by pool-98-113-39-171.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 23:27:07 +0100
To: linux-wireless@vger.kernel.org
From: Eric Appleman <erappleman@gmail.com>
Subject: [BUG] Rate control regression for Intel Wireless 6230 with 3.8 kernel
Date: Thu, 7 Feb 2013 22:26:28 +0000 (UTC)
Message-ID: <loom.20130207T232512-274@post.gmane.org> (sfid-20130207_232656_926273_0AD863F6)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Logs: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1103314

There seem to be huge throttling issues with iwlwifi when n-mode is enabled.

I've only confirmed this with an Intel 6230 and it seems specific to 3.8.

