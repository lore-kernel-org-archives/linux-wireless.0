Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:34046 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYLALLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:11:12 -0500
Received: by ug-out-1314.google.com with SMTP id 39so2620639ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 03:11:10 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 0/3] Code fixups and optimisation
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 12:11:08 +0100
Message-ID: <20081201111021.20833.42515.stgit@localhost> (sfid-20081201_121115_703095_5353EE46)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After fixing the Makefile I have taken a look at the actual code, just
three simple patches for that.

---

Diego 'Flameeyes' Petten=C3=B2 (3):
      Avoid implicit declaration of memset() with OpenSSL.
      Mark constant the generated key tables for libgcrypt.
      Mark functions static when not used outside their translation uni=
t.


 intersect.c      |    2 +-
 reglib.c         |    5 +++--
 reglib.h         |    3 ---
 utils/key2pub.py |    6 +++---
 4 files changed, 7 insertions(+), 9 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
