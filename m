Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A73C001DF
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Jul 2023 10:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjGXKp5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Jul 2023 06:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbjGXKp4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2023 06:45:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D56A9C
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2023 03:45:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF53C61074
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2023 10:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023A4C433C8
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2023 10:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690195554;
        bh=yhKePRwKZ+K/VRhHQCUcN0lLdkciTJNuFJwC4/IccZk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rqGFQu6/BztjenfOtiotjidfPjN5Mn8rXDQL4BWPi0DXI58n5X7leIEaLzGtyC1P5
         QUjchiJ7+tnPpR25zzf6d5+YO3D3u3WpUuJjFQHhlWPbKyOQyocPLXu9GUtEzWG004
         cBS0BF7mhxViS8eCFVAvBEBAgwKzb8B1xGXVGgWv/Nc2T9NwdIyNJB61OGM6MRqHLP
         TGbM+zJkTpRsnRVWdOoMPVMPjquQ/Zl1drjR0PejFRIgWIssoL8o0xGiZGvbdyRfdx
         MtHbSLgDB3sQsJsn8GAbYMs7IRINgpgQUquRZL0Jmua5e8o4icSFZN1YGZHu9b4urp
         0TKAXcMZDu2Ag==
From:   Kalle Valo <kvalo@kernel.org>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 5/9] MAINTAINERS: wifi: mark rndis_wlan as orphan
Date:   Mon, 24 Jul 2023 13:45:43 +0300
Message-Id: <20230724104547.3061709-6-kvalo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230724104547.3061709-1-kvalo@kernel.org>
References: <20230724104547.3061709-1-kvalo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Last activity from Jussi for this driver is from 2013 so mark the driver
orphan.

Signed-off-by: Kalle Valo <kvalo@kernel.org>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 71a9ef392583..b041bc1be8b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22165,9 +22165,8 @@ F:	drivers/usb/gadget/legacy/webcam.c
 F:	include/uapi/linux/usb/g_uvc.h
 
 USB WIRELESS RNDIS DRIVER (rndis_wlan)
-M:	Jussi Kivilinna <jussi.kivilinna@iki.fi>
 L:	linux-wireless@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/legacy/rndis_wlan.c
 
 USB XHCI DRIVER
-- 
2.39.2

