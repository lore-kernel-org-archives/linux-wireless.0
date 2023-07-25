Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477B5C0015E
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jul 2023 09:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbjGYJnK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jul 2023 05:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjGYJmx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2023 05:42:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B2A128
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2023 02:42:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33842615D1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2023 09:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A08FC433C8;
        Tue, 25 Jul 2023 09:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690278171;
        bh=K0q3hxr2miXWjf12Pi9Tt2qxj8zRYXBEa4bLBHdyHdo=;
        h=From:To:Cc:Subject:Date:From;
        b=VvPakJ031k8agtqJmw1+tACFRzv63eN0DodmonkFf31Hn71eN4UZGIvbgg5oV/nIp
         LnSMFHWWqR1oaQhMKwcJ2ov+hAbfQaWUarUk9MOsAG8tmyXPINherpdbtbnPufjJBQ
         IO7RbEtEWSybShflByL35Rb1Xp/9E4cX4bna884lBgl3cBIMzKMBYnM6Au9LRY1Fzb
         cqKgUFGvEQDz/2KOw03beRRIrB1Jekobx/HPDISC3RDfmPaqJRVHN7rdxJbuVSvvtF
         bdnXXONAdvDz8G6EtS3TpZ/QYVO8tIL+IChaN91cnRVrLClsBVAiNwKnoZQjCK+OtH
         skjdEJxzNvCbg==
From:   Kalle Valo <kvalo@kernel.org>
To:     ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add Jeff as ath10k, ath11k and ath12k maintainer
Date:   Tue, 25 Jul 2023 12:42:48 +0300
Message-Id: <20230725094248.3205486-1-kvalo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jeff will now start maintaining these drivers together with me.

Signed-off-by: Kalle Valo <kvalo@kernel.org>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 42e78a696be6..292910ef17d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17433,6 +17433,7 @@ F:	drivers/media/tuners/qt1010*
 
 QUALCOMM ATH12K WIRELESS DRIVER
 M:	Kalle Valo <kvalo@kernel.org>
+M:	Jeff Johnson <quic_jjohnson@quicinc.com>
 L:	ath12k@lists.infradead.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
@@ -17440,6 +17441,7 @@ F:	drivers/net/wireless/ath/ath12k/
 
 QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
 M:	Kalle Valo <kvalo@kernel.org>
+M:	Jeff Johnson <quic_jjohnson@quicinc.com>
 L:	ath10k@lists.infradead.org
 S:	Supported
 W:	https://wireless.wiki.kernel.org/en/users/Drivers/ath10k
@@ -17449,6 +17451,7 @@ F:	drivers/net/wireless/ath/ath10k/
 
 QUALCOMM ATHEROS ATH11K WIRELESS DRIVER
 M:	Kalle Valo <kvalo@kernel.org>
+M:	Jeff Johnson <quic_jjohnson@quicinc.com>
 L:	ath11k@lists.infradead.org
 S:	Supported
 W:	https://wireless.wiki.kernel.org/en/users/Drivers/ath11k

base-commit: a2777be03236c00466326acba8d39ac4f9c3e971
-- 
2.39.2

