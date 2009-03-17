Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45741 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZCQGBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 02:01:35 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 23:01:34 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18879.15297.344575.231076@gargle.gargle.HOWL> (sfid-20090317_070138_729631_C0D0761C)
Date: Tue, 17 Mar 2009 11:27:21 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@Atheros.com>
Subject: Missing commits in wireless-testing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Luis' serialization patches have been merged in wireless-testing,
but the commit IDs are missing. I did a git pull today and
git-describe shows: v2.6.29-rc8-18593-gef1cb6f

No compilation breakage, though.

Sujith
