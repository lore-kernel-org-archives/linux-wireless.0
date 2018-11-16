Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3B2C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04EC12086A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:31:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04EC12086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389554AbeKPVnr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 16:43:47 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:47281 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389523AbeKPVnr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 16:43:47 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID wAGBVdE2020489, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id wAGBVdE2020489
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Fri, 16 Nov 2018 19:31:39 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Nov 2018 19:31:38 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>
Subject: [PATCH v2 13/13] rtw88: add support for Realtek 802.11ac wireless chips
Date:   Fri, 16 Nov 2018 19:31:19 +0800
Message-ID: <1542367879-28880-14-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
References: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
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

