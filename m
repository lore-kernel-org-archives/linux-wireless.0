Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395D9C433EF
	for <linux-wireless@archiver.kernel.org>; Fri, 10 Jun 2022 13:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244347AbiFJNgt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 10 Jun 2022 09:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiFJNgs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Jun 2022 09:36:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8FB396B0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2022 06:36:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67EA261AAC
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2022 13:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C32C3411D;
        Fri, 10 Jun 2022 13:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654868205;
        bh=eWtXFCIMMjAECVlg9VhbeBeG9zH5I9ug3qsVfDGrJqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJ3V4kt/wphjanHfPRz/ZOgFljSKViw96sn1+/A5OPFmLryR7H/QnLE8lcP3xSalP
         ub7bthVbGo1cHhMPS45uH1a3dP0RA2zWEQoJ2maGSa/CDGGhtJ5BKEjjQk3xt/xnZ+
         zu2f7aUofbGD7ImjoONOxeq5UKmnqNA4IbLv7oPG0jaKcdGVdrEjlRgcMPjlMX8YEc
         8CkhXjf73JCZRTgQGHitoGYZTaC7gBGlRqoxLnwtOB2Pjs8f6oNE8mMxKmEHze6iew
         WaYqEyDu3WIIdj9+RmYJbRsu18HWqUY5+FjRpbKg8qa3zOLUxQ01SkqwFSTRhfMMWE
         AlA+gMh4iCueQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH wireless v2 2/2] dt-bindings: net: wireless: ath11k: change Kalle's email
Date:   Fri, 10 Jun 2022 16:36:40 +0300
Message-Id: <20220610133640.10810-2-kvalo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220610133640.10810-1-kvalo@kernel.org>
References: <20220610133640.10810-1-kvalo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <quic_kvalo@quicinc.com>

My codeaurora.org email doesn't work anymore, so switch to my preferred
kernel.org address.

Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
---
 Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
index 8c01fdba134b..a677b056f112 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
@@ -9,7 +9,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Qualcomm Technologies ath11k wireless devices Generic Binding
 
 maintainers:
-  - Kalle Valo <kvalo@codeaurora.org>
+  - Kalle Valo <kvalo@kernel.org>
 
 description: |
   These are dt entries for Qualcomm Technologies, Inc. IEEE 802.11ax
-- 
2.30.2

