Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A986EC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 07:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83CBA20896
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 07:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731947AbfDAHRD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 03:17:03 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:2923 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731898AbfDAHQz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 03:16:55 -0400
X-UUID: fda522bb369c4ce3ad6701d3c7a79b79-20190401
X-UUID: fda522bb369c4ce3ad6701d3c7a79b79-20190401
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1142359240; Mon, 01 Apr 2019 15:16:49 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 1 Apr 2019 15:16:47 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 1 Apr 2019 15:16:47 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
CC:     Roy Luo <royluo@google.com>, Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        YF Luo <yf.luo@mediatek.com>, Kai Lin <kai.lin@mediatek.com>,
        Rorscha Yang <rorscha.yang@mediatek.com>,
        Kyle Lee <kyle.lee@mediatek.com>,
        Miller Shen <miller.shen@mediatek.com>,
        Haipin Liang <haipin.liang@mediatek.com>,
        KL Huang <kl.huang@mediatek.com>,
        YH chen <yh.chen@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v3 4/4] MAINTAINERS : update entry for mt76 wireless driver
Date:   Mon, 1 Apr 2019 15:16:44 +0800
Message-ID: <ce2f7b967021b9c3e64aa846084a816efd7f6002.1554102584.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1554102584.git.ryder.lee@mediatek.com>
References: <cover.1554102584.git.ryder.lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 2BB8D97884A486168A52FCFD5260C0EE031937706E13C765D8FD80244D11E2ED2000:8
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Roy and I actively join the development and review.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e17ebf7..7d92a87 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9768,6 +9768,8 @@ F:	Documentation/devicetree/bindings/media/mediatek-vpu.txt
 MEDIATEK MT76 WIRELESS LAN DRIVER
 M:	Felix Fietkau <nbd@nbd.name>
 M:	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+R:	Ryder Lee <ryder.lee@mediatek.com>
+R:	Roy Luo <royluo@google.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/mediatek/mt76/
-- 
1.9.1

