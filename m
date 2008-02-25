Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:21799 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbYBYWQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:16:58 -0500
Received: by ug-out-1314.google.com with SMTP id z38so996346ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:16:56 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 0/4] rt2x00: Stable updates
Date: Mon, 25 Feb 2008 23:14:54 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802252314.55404.IvDoorn@gmail.com> (sfid-20080225_221702_441513_1797A7AF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This patch series is intended for the 2.6.25 kernel,
they (should) fix the reported regression for the rt61pci
driver (Possibly the other rt2x00 drivers as well, but nobody
reported any other regressions for the 2.6.25 kernel yet).

I'll send the patches for the wireless-testing tree separately
along with some other patches intended only for wireless-testing.

Ivo
