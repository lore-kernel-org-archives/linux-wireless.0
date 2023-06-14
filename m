Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AABEB64D8
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Jun 2023 14:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244537AbjFNOrL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Jun 2023 10:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244306AbjFNOrK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2023 10:47:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CBF1BEC
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2023 07:47:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8040612DC
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2023 14:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9F1C433C8
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2023 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686754028;
        bh=dpcDNIpTrTbOc5wKVbpx4QHCZoYUc3e6lgeVOh1bFlk=;
        h=From:To:Subject:Date:From;
        b=hYGchH8vALWFojpkS1+y9iNhjYDqO4LmpnWC9a5xx6x7QFa3PN93GYOPT2Pvz7ybS
         ja83mfKoy3DCt8DonMjfbl9b8cUPSY/5X4nQc24wdqy/zsd+GyOJnHxfm7TdeSUyic
         Qm6usQXyQoTNHkoESpHz3x5gZIliddstuKK9bCVGGXSA9nQiMTLGfZAHh7erW8Mx0T
         Ue7/yRkWJCkAkLWGJHI/7VzMyMsYRoINlzdOkG0Xxm8KrTqEk+Ujg3NmmVbemvtVdD
         q3+sdD4hkIDQWkPzGfjFYXFU2kOIa8m5ugF6t9Ku4dE3NO9UJLfmHv73KQzxlkYivv
         t/wt+ZRDy74+A==
From:   Kalle Valo <kvalo@kernel.org>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] MAINTAINERS: mt76: add git tree
Date:   Wed, 14 Jun 2023 17:47:02 +0300
Message-Id: <20230614144704.505553-1-kvalo@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix has a git tree for mt76 patches, document that.

Signed-off-by: Kalle Valo <kvalo@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0971854323a7..f7d7fdf47dd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13212,6 +13212,7 @@ R:	Shayne Chen <shayne.chen@mediatek.com>
 R:	Sean Wang <sean.wang@mediatek.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+T:	git https://github.com/nbd168/wireless
 F:	Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
 F:	drivers/net/wireless/mediatek/mt76/
 

base-commit: 93ae81454b1107843ad36dcdc457dd10ee0f2cbe
-- 
2.30.2

