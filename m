Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW4.Sony.CO.JP ([137.153.0.46]:59344 "EHLO mgw4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbYAVGWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 01:22:31 -0500
Received: from mail2.sony.co.jp (localhost [127.0.0.1])
	by mail2.sony.co.jp (R8/Sony) with ESMTP id m0M6MTfc006872
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 15:22:29 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
	by mail2.sony.co.jp (R8/Sony) with ESMTP id m0M6MTcB006842
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 15:22:29 +0900 (JST)
Received: from imail.sm.sony.co.jp (imail.sm.sony.co.jp [43.4.141.32]) by smail1.sm.sony.co.jp (8.11.6p2/8.11.6) with ESMTP id m0M6MTe02314 for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 15:22:29 +0900 (JST)
Received: from [43.4.146.40] (bluenote.sm.sony.co.jp [43.4.146.40])
	by imail.sm.sony.co.jp (8.12.11/3.7W) with ESMTP id m0M6MTmR013868
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 15:22:29 +0900 (JST)
Date: Tue, 22 Jan 2008 15:22:29 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] WEXT: remove unused variable
Message-Id: <20080122125500.613E.40F06B3A@sm.sony.co.jp> (sfid-20080122_062233_743768_2047E53F)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As event_type_pk_size[] is not used,  Remove it.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 net/wireless/wext.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/net/wireless/wext.c
+++ b/net/wireless/wext.c
@@ -417,20 +417,6 @@ static const int event_type_size[] = {
 	IW_EV_QUAL_LEN,			/* IW_HEADER_TYPE_QUAL */
 };
 
-/* Size (in bytes) of various events, as packed */
-static const int event_type_pk_size[] = {
-	IW_EV_LCP_PK_LEN,		/* IW_HEADER_TYPE_NULL */
-	0,
-	IW_EV_CHAR_PK_LEN,		/* IW_HEADER_TYPE_CHAR */
-	0,
-	IW_EV_UINT_PK_LEN,		/* IW_HEADER_TYPE_UINT */
-	IW_EV_FREQ_PK_LEN,		/* IW_HEADER_TYPE_FREQ */
-	IW_EV_ADDR_PK_LEN,		/* IW_HEADER_TYPE_ADDR */
-	0,
-	IW_EV_POINT_PK_LEN,		/* Without variable payload */
-	IW_EV_PARAM_PK_LEN,		/* IW_HEADER_TYPE_PARAM */
-	IW_EV_QUAL_PK_LEN,		/* IW_HEADER_TYPE_QUAL */
-};
 
 /************************ COMMON SUBROUTINES ************************/
 /*

-- 
Masakazu MOKUNO

