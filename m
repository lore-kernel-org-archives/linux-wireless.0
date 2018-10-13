Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9487CC71122
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 09:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44C2220835
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 09:01:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44C2220835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbeJMQhl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 12:37:41 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60278 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbeJMQhj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 12:37:39 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9D913gV001016, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9D913gV001016
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Sat, 13 Oct 2018 17:01:03 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Sat, 13 Oct 2018 17:01:02 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <pkshih@realtek.com>,
        <tehuang@realtek.com>, <sgruszka@redhat.com>,
        <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [RFC v4 13/13] rtw88: add support for Realtek 802.11ac wireless chips
Date:   Sat, 13 Oct 2018 17:00:45 +0800
Message-ID: <1539421245-11847-14-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
References: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9ad052a..138515b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12546,6 +12546,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.g
 S:	Maintained
 F:	drivers/net/wireless/realtek/rtlwifi/
 
+REALTEK WIRELESS DRIVER (rtw88)
+M:	Yan-Hsuan Chuang <yhchuang@realtek.com>
+L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
+S:	Maintained
+F:	drivers/net/wireless/realtek/rtw88/
+
 RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
 M:	Jes Sorensen <Jes.Sorensen@gmail.com>
 L:	linux-wireless@vger.kernel.org
-- 
2.7.4

