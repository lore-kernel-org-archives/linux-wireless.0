Return-Path: <SRS0=g+pd=SV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D290C282E0
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 18:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58D82222E9
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 18:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfDSSSl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:18:41 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:45766 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbfDSSSk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Apr 2019 14:18:40 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x3J5p0X6020844, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x3J5p0X6020844
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 19 Apr 2019 13:51:00 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV02.realtek.com.tw (172.21.6.19) with Microsoft SMTP Server id
 14.3.439.0; Fri, 19 Apr 2019 13:50:59 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <Larry.Finger@lwfinger.net>, <sgruszka@redhat.com>,
        <briannorris@chromium.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH v9 13/14] rtw88: add MAINTAINERS entry
Date:   Fri, 19 Apr 2019 13:50:03 +0800
Message-ID: <1555653004-1795-14-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1555653004-1795-1-git-send-email-yhchuang@realtek.com>
References: <1555653004-1795-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Add an entry for rtw88 in MAINTAINERS

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d90e4e3..8760f30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13177,6 +13177,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.g
 S:	Maintained
 F:	drivers/net/wireless/realtek/rtlwifi/
 
+REALTEK WIRELESS DRIVER (rtw88)
+M:	Yan-Hsuan Chuang <yhchuang@realtek.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/realtek/rtw88/
+
 RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
 M:	Jes Sorensen <Jes.Sorensen@gmail.com>
 L:	linux-wireless@vger.kernel.org
-- 
2.7.4

