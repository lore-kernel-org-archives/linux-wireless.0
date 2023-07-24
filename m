Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BA9C001B0
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Jul 2023 10:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjGXKp6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Jul 2023 06:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjGXKp4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2023 06:45:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBA8E6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2023 03:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB37261073
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2023 10:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19B8C433C7
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2023 10:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690195555;
        bh=ox+RMfzEPURiaCUVLxZYa4l6QglP9MbLjMtnMps+gOE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FFpJGtQ9Ti3C0IcxTjGkgyIeF2a6dm+NZJfYk3d4Wpp8+yNA4IL9lDHXwA88KsctX
         y+Oc+W/EBSG7Tz9arqRZxmA4dSOaaGh62GaMeDVWVJZ3DG5imIH0z/21p/nUD3++IA
         CG7WtXCNLLjqsv7/3mJVMUzoL2seDLfbHs+WQPr+ekupCnxQZwOBD4P0hBZBKqs3vQ
         OzIkRMS4mLG3kihXlDCKruj1wkXFUqPPCAZHr8wNXdPbc4Wn6g2cayMUWlVVs+BtwM
         gdrhfrYnDwlD4Qr3crgZwtr8GV3PVcmAIurkf4AiepFq527cggN5DXWXovYkDyA0f2
         gra5r20ZViQhA==
From:   Kalle Valo <kvalo@kernel.org>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 6/9] MAINTAINERS: wifi: mark wl3501 as orphan
Date:   Mon, 24 Jul 2023 13:45:44 +0300
Message-Id: <20230724104547.3061709-7-kvalo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230724104547.3061709-1-kvalo@kernel.org>
References: <20230724104547.3061709-1-kvalo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There's no maintainer for this driver so mark it as orphan.

Signed-off-by: Kalle Valo <kvalo@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b041bc1be8b0..bfb423f5f4c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22941,7 +22941,7 @@ F:	drivers/input/misc/wistron_btns.c
 
 WL3501 WIRELESS PCMCIA CARD DRIVER
 L:	linux-wireless@vger.kernel.org
-S:	Odd fixes
+S:	Orphan
 F:	drivers/net/wireless/legacy/wl3501*
 
 WMI BINARY MOF DRIVER
-- 
2.39.2

