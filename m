Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB1FC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 09:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64DB82070B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 09:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733091AbfC0J6v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 05:58:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732541AbfC0J6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 05:58:49 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ACCA23005FE6;
        Wed, 27 Mar 2019 09:58:49 +0000 (UTC)
Received: from localhost (unknown [10.40.205.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41B0460C18;
        Wed, 27 Mar 2019 09:58:49 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH 8/8] rt2x00mmio: remove legacy comment
Date:   Wed, 27 Mar 2019 10:58:31 +0100
Message-Id: <1553680711-15730-9-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1553680711-15730-1-git-send-email-sgruszka@redhat.com>
References: <1553680711-15730-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 27 Mar 2019 09:58:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove comment about fields that were removed.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00mmio.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.h b/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.h
index 184a4148b2f8..03e6cdb0b5a4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.h
@@ -80,8 +80,6 @@ int rt2x00mmio_regbusy_read(struct rt2x00_dev *rt2x00dev,
  *
  * @desc: Pointer to device descriptor
  * @desc_dma: DMA pointer to &desc.
- * @data: Pointer to device's entry memory.
- * @data_dma: DMA pointer to &data.
  */
 struct queue_entry_priv_mmio {
 	__le32 *desc;
-- 
2.7.5

