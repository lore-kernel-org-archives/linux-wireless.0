Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35379 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbbH1MhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 08:37:11 -0400
Received: by qkbm65 with SMTP id m65so27016880qkb.2
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2015 05:37:10 -0700 (PDT)
From: Kylie McClain <somasissounds@gmail.com>
Subject: [PATCH] utils/key2pub: use python2 explicitly
To: linux-wireless@vger.kernel.org
Message-ID: <55E055E4.7030000@gmail.com> (sfid-20150828_143715_686987_20E0A513)
Date: Fri, 28 Aug 2015 08:36:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On systems that have python3 as the default /usr/bin/python provider,
specifying `python` causes the build to fail.

>From f4607ed246476b3ed58b4ce25cfdc6348a4a6bd1 Mon Sep 17 00:00:00 2001
From: Kylie McClain <somasis@exherbo.org>
Date: Thu, 27 Aug 2015 21:29:48 -0400
Subject: [PATCH] utils/key2pub: use python2 explicitly

Signed-off-by: Kylie McClain <somasis@exherbo.org>
---
 utils/key2pub.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/key2pub.py b/utils/key2pub.py
index 3e84cd2..8bea042 100755
--- a/utils/key2pub.py
+++ b/utils/key2pub.py
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python2

 import sys
 try:
-- 
2.5.0

-- 
Kylie McClain, Exherbo Linux developer and Musician
https://somasis.com - https://github.com/Somasis

