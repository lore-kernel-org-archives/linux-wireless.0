Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43253 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbZFJQZh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 12:25:37 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 09:25:40 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <jouni.malinen@atheros.com>, <luis.rodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 0/7] ATH9K bug fixes - TX hang & Signal Quality issue
Date: Wed, 10 Jun 2009 21:55:25 +0530
Message-ID: <1244651133-6537-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seris fixes couple of important issues

1) Signal Quality issue (patch 1/7)
2) INI update - fixes performance issue (Patch 2/7)
3) TX hang issue (happens after an hour time, Patch 6/7 & 7/7)

Thanks
Senthil

