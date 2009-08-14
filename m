Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40907 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbZHNDlu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 23:41:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 20:41:52 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19076.56592.101907.186453@gargle.gargle.HOWL>
Date: Fri, 14 Aug 2009 09:12:08 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Revert commit in ath9k
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Can you revert the commit - "ath9k: Change DEBUG level for certain interrupts" ?
This interrupt seems to trigger fairly often and floods the log.
The driver does seem to work with this message suppressed.
(which was the original behaviour).

The actual cause for this bug is still unknown, but until it is
found and fixed, the earlier behaviour can be retained.

Sorry for the trouble. :)

Sujith
