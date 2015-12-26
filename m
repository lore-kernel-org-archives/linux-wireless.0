Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33890 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbLZPFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Dec 2015 10:05:13 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCH] RFKill airplane mode LED trigger
Date: Sat, 26 Dec 2015 10:05:02 -0500
Message-Id: <1451142303-1872-1-git-send-email-jprvita@endlessm.com> (sfid-20151226_160638_417793_356FA355)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a LED trigger to drive the airplane mode LED present in some
modern laptops. It will be used by the asus-wireless platform driver, which is
currently under review on platform-driver-x86@vger.kernel.org (the idea was
mainly approved, but I'm addressing some comments by the maintainers).

João Paulo Rechi Vita (1):
  net/rfkill: Create "airplane mode" LED trigger

 net/rfkill/core.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

-- 
2.5.0

