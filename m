Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:37657 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYJWXFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 19:05:42 -0400
Received: by fk-out-0910.google.com with SMTP id 18so373113fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 16:05:40 -0700 (PDT)
Date: Fri, 24 Oct 2008 01:05:35 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [CRDA PATCH 2/6] Ignore more binary files.
Message-ID: <20081023230535.GA8837@PesaBook.pesa.homelinux.org> (sfid-20081024_010545_162538_C38F50BB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Davide Pesavento <davidepesa@gmail.com>
---
 .gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 317d9fd..cc39545 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,7 +1,9 @@
 *~
 regulatory.sqlite
 regulatory.bin
+crda
 dump
+*.o
 *.pyc
 keys-*.c
 key.priv.pem
-- 
1.6.0.2

