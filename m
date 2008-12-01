Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:32106 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYLAKbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 05:31:24 -0500
Received: by ug-out-1314.google.com with SMTP id 39so2608758ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 02:31:23 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 5/5] Ignore built files.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 11:31:21 +0100
Message-ID: <20081201103121.18024.54799.stgit@localhost> (sfid-20081201_113127_149838_961D4D5E)
In-Reply-To: <20081201103016.18024.80454.stgit@localhost>
References: <20081201103016.18024.80454.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>

Signed-off-by: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>
---

 .gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index cc39545..8ee749e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -3,6 +3,8 @@ regulatory.sqlite
 regulatory.bin
 crda
 dump
+intersect
+regdbdump
 *.o
 *.pyc
 keys-*.c

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
