Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE24BC282DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DD3B20857
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfDILhZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfDILhY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB3CD3005FC1;
        Tue,  9 Apr 2019 11:37:23 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72A5269181;
        Tue,  9 Apr 2019 11:37:23 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>,
        Gabor Juhos <juhosg@openwrt.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 01/21] rt2x00: rt2800lib: enable support for RT3883
Date:   Tue,  9 Apr 2019 13:36:48 +0200
Message-Id: <1554809828-13500-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 09 Apr 2019 11:37:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a03b5284a050..071465854a45 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -9570,6 +9570,7 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
 	case RT3390:
 	case RT3572:
 	case RT3593:
+	case RT3883:
 	case RT5350:
 	case RT5390:
 	case RT5392:
-- 
2.7.5

