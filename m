Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2ECC001DF
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Jul 2023 10:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjGXKpy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Jul 2023 06:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjGXKpx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2023 06:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AA69C
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2023 03:45:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E6F661074
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2023 10:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947D4C433C9
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2023 10:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690195551;
        bh=ecSJ0yFUHSH9KK5e65IpolAI1p8jR8bP73BKCy7lpy0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Da+5btsDHJ5NIuQaF+hF/zMfISbq8TfKw+MdsaEGRT67Vb+UbNRrcox33pXD3BGrS
         VNleaXhfLgXKp2K15CY3ZFv9xkjR7zT/oHeYDVprWrckzY0/ShpxXxe7dcawXUudGp
         w83gpTGuU67Obt14+fmZGZ4+SZp/F28gkcp8M855QXRcEzN0kLTj3AIHn9Mb1bxnbx
         5lwtfGEkyXxfJcqcT9Y+O3XD3bijPA1FkVOfcSjI0cOW4vKWyDxghoInvYQyM/bxwu
         gcDIz/UeSG1F0McSFZYXl8Gk9DU9KLe5M1Rw2hJy3f/Z7yIjaIhUGJV8rpZfEAVMbX
         JX2ybK9vaKHLw==
From:   Kalle Valo <kvalo@kernel.org>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/9] MAINTAINERS: wifi: rtw88: change Ping as the maintainer
Date:   Mon, 24 Jul 2023 13:45:39 +0300
Message-Id: <20230724104547.3061709-2-kvalo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230724104547.3061709-1-kvalo@kernel.org>
References: <20230724104547.3061709-1-kvalo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yan-Hsuan has been away since 2021 and Ping has been the de facto maintainer
the past year, actively reviewing patches and doing all other maintainer
duties. So fix the MAINTAINERS file to show the current situation.

Signed-off-by: Kalle Valo <kvalo@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dfbb271f1667..b61f43595e8d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17972,7 +17972,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.g
 F:	drivers/net/wireless/realtek/rtlwifi/
 
 REALTEK WIRELESS DRIVER (rtw88)
-M:	Yan-Hsuan Chuang <tony0620emma@gmail.com>
+M:	Ping-Ke Shih <pkshih@realtek.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/realtek/rtw88/
-- 
2.39.2

