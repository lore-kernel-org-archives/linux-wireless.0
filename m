Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 644E2C19F2D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Aug 2022 16:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238998AbiHLQLX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Aug 2022 12:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239261AbiHLQLO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Aug 2022 12:11:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE837A721D
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2022 09:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 961B5B82490
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2022 16:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B132CC433D6;
        Fri, 12 Aug 2022 16:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660320658;
        bh=4S0ctAgJxaRMot9ezZoNGGdbm/MGqGvprRUthHCdQSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0Es7MxyMK2JY8n5secw4JJNPExSFv9vFMVcVZMKK21II8h8ZQoaqrbiNYyuIdfP1
         vsyonaXe00ZEBNbL+8loutOehlMxZtqtyNuegsmr7K9jjQ3azV0IqYL1X22NogqqDd
         VBYJvxzMB7Zx4CnWyhkXri6NygnVYOJsw+gbaQX4LCtD8J5WGR2+ic8ly/9WkWq3Be
         3YNCuBBNz4cZM+ydYRA6wK97ReBQTGmwYnG6dKKIh9xeD8oBZ3KUgCqBDLykve9VyW
         Vf/j3GAO8Q+FvcqegGYdxQZnCo108zvcfelVyA8IUF8Jyv7scBvmBlvtijgv7uiY4X
         WmrXeItCIeKPw==
From:   Kalle Valo <kvalo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath12k@lists.infradead.org
Subject: [PATCH 49/50] wifi: ath: add ath12k to Kconfig
Date:   Fri, 12 Aug 2022 19:10:02 +0300
Message-Id: <20220812161003.27279-50-kvalo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220812161003.27279-1-kvalo@kernel.org>
References: <20220812161003.27279-1-kvalo@kernel.org>
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

