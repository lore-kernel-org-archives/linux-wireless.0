Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA6BC65BB3
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 15:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8825A20821
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 15:46:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8825A20821
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbeLJPqj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 10:46:39 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45423 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbeLJPqj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 10:46:39 -0500
Received: by mail-wr1-f68.google.com with SMTP id b14so10953907wru.12
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2018 07:46:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5OfBkKezWZRwBnVMcdO9OZDKVr6QIl4Kdr/asIz/PpU=;
        b=WVfyfrSy4PuOdvPsObYucpf/p6WcYwqcM7I56j4J0gIxPJPAnube8pWmPNWP40AUTL
         6igYCfkKi5jqlcFzWZUdOPdaOP6rik4U4D1Ze7Hb0eEscOXQdYiTDK8vWho1v7ByGl+O
         Jtyt6t3uue4ajIPxJPCLK0LNqnYHEJRTAX1Bz/2wHJ4BF1bOuAngA2Xoh99l7BIa92c7
         ZqNSS6uBfp2bbIRGEd9hSOWCXJrSzHM1z8RaUfN2w4QjBv4U36XhYNKaPf1EqXXktF5D
         7PcbFCeqVzGlmCTvzNebDg/gFIvOfwK9x0i6hA6pkfb3HWGhYg/3PSlDaEKiIlv1m4Rv
         HMyw==
X-Gm-Message-State: AA+aEWZOc8PB4/soybFdyzUsPa/MGWle4s3zttxUDolio7t3mj7j0doT
        hordByaOBcSKDUpWjsIJ9UGqEJ2eTMY=
X-Google-Smtp-Source: AFSGD/XAo96HLSDuPAtjZ1TU+JZoJtVMWtDijFTlUc+juvOv1LUu487IlCkO1DvIgYfj77Z7q4TvJw==
X-Received: by 2002:adf:aac6:: with SMTP id i6mr10047958wrc.216.1544456797570;
        Mon, 10 Dec 2018 07:46:37 -0800 (PST)
Received: from localhost.localdomain ([151.66.36.11])
        by smtp.gmail.com with ESMTPSA id i186sm3340331wmd.19.2018.12.10.07.46.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 07:46:36 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: add entry in MAINTAINERS file
Date:   Mon, 10 Dec 2018 16:46:28 +0100
Message-Id: <47d46d5627fee5691f7faf682d385c2aa3a537d4.1544456498.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1544456498.git.lorenzo.bianconi@redhat.com>
References: <cover.1544456498.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add entry for mt76 driver in MAINTAINERS file

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f4855974f325..903b942c0b96 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9353,6 +9353,13 @@ F:	drivers/media/platform/mtk-vpu/
 F:	Documentation/devicetree/bindings/media/mediatek-vcodec.txt
 F:	Documentation/devicetree/bindings/media/mediatek-vpu.txt
 
+MEDIATEK MT76 WIRELESS LAN DRIVER
+M:	Felix Fietkau <nbd@nbd.name>
+M:	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/mediatek/mt76/
+
 MEDIATEK MT7601U WIRELESS LAN DRIVER
 M:	Jakub Kicinski <kubakici@wp.pl>
 L:	linux-wireless@vger.kernel.org
-- 
2.19.2

