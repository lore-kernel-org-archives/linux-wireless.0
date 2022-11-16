Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273FFC4332F
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Nov 2022 16:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbiKPQou (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Nov 2022 11:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239047AbiKPQnt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2022 11:43:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1E31CFD6
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2022 08:40:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE37C61EFB
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2022 16:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0394C43144;
        Wed, 16 Nov 2022 16:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668616799;
        bh=4S0ctAgJxaRMot9ezZoNGGdbm/MGqGvprRUthHCdQSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNH3gIV3JwMEQKZZu9prjX1/PTOsFHcv9OKY2SdjoQGyZP80cYy2yXOL85R1Z3fI1
         DdN+gYTwI8TUIRRimvYVvMHBxwAhenr6MKeF4rdtl5RH7OwshAc9TRUFbdq8GUf0wN
         e3eXme5yeFTDcAJNP+zuwXpJQEqKJbaLhZAWjxkICsHNGqhJosY7dtrf1XjyeI0fd7
         0iJC0vn8qKt9MdNAz33UHFKAvRATfZxoM5X2PzGzAyRZ5zqVLQjPTXWbIBvjopCVg7
         59UNST9EXytPDj3SgesiGoocsXAcRO1V8wAkWfKU4LP4OgQ62bkx4Ebhw4TTa0wNLX
         clyt1AfnipXOQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath12k@lists.infradead.org
Subject: [PATCH v2 49/50] wifi: ath: add ath12k to Kconfig
Date:   Wed, 16 Nov 2022 18:39:01 +0200
Message-Id: <20221116163902.24996-50-kvalo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221116163902.24996-1-kvalo@kernel.org>
References: <20221116163902.24996-1-kvalo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <quic_kvalo@quicinc.com>

(Patches split into one patch per file for easier review, but the final
commit will be one big patch. See the cover letter for more info.)

Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
---
 drivers/net/wireless/ath/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index d88edbf1bea3..910c10028b14 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -63,5 +63,6 @@ source "drivers/net/wireless/ath/wil6210/Kconfig"
 source "drivers/net/wireless/ath/ath10k/Kconfig"
 source "drivers/net/wireless/ath/wcn36xx/Kconfig"
 source "drivers/net/wireless/ath/ath11k/Kconfig"
+source "drivers/net/wireless/ath/ath12k/Kconfig"
 
 endif

