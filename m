Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36747 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbJQVL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 17:11:29 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] net: wireless: rt2x00: Space Required
Date: Sat, 17 Oct 2015 22:11:23 +0100
Message-Id: <1445116283-28748-1-git-send-email-paulmcquad@gmail.com> (sfid-20151017_231150_257951_74204068)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Space needed before open parenthesis

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 90fdb02..25ee3cb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -629,7 +629,7 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	data += sprintf(data, "register\tbase\twords\twordsize\n");
 #define RT2X00DEBUGFS_SPRINTF_REGISTER(__name)			\
 {								\
-	if(debug->__name.read)					\
+	if (debug->__name.read)					\
 		data += sprintf(data, __stringify(__name)	\
 				"\t%d\t%d\t%d\n",		\
 				debug->__name.word_base,	\
@@ -699,7 +699,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 
 #define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)			\
 ({										\
-	if(debug->__name.read) {						\
+	if (debug->__name.read) {						\
 		(__intf)->__name##_off_entry =					\
 		debugfs_create_u32(__stringify(__name) "_offset",		\
 				       S_IRUSR | S_IWUSR,			\
-- 
2.6.1

