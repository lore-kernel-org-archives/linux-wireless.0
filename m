Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2DCC41513
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Aug 2023 07:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjHCHiY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Aug 2023 03:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbjHCHgc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:32 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 9672630FA;
        Thu,  3 Aug 2023 00:34:33 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 671346090B390;
        Thu,  3 Aug 2023 15:34:29 +0800 (CST)
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From:   Wu Yunchuan <yunchuan@nfschina.com>
To:     kvalo@kernel.org
Cc:     simon.horman@corigine.com, yuancan@huawei.com, marex@denx.de,
        peter@n8pjl.ca, johannes.berg@intel.com, alexander@wetzel-home.de,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Wu Yunchuan <yunchuan@nfschina.com>
Subject: [PATCH net-next v2 0/9] wifi: rsi: Remove some unnecessary conversions
Date:   Thu,  3 Aug 2023 15:34:17 +0800
Message-Id: <20230803073417.3666063-1-yunchuan@nfschina.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

remove unnecessary (void*) conversions and other unnecessary
conversons in the directory drivers/net/wireless/rsi. 

changes from v2 to v1:
 - modify subject lines

Wu Yunchuan (9):
  wifi: rsi: rsi_91x_coex: Remove unnecessary (void*) conversions
  wifi: rsi: rsi_91x_debugfs: Remove unnecessary (void*) conversions
  wifi: rsi: rsi_91x_hal: Remove unnecessary conversions
  wifi: rsi: rsi_91x_mac80211: Remove unnecessary conversions
  wifi: rsi: rsi_91x_main: Remove unnecessary (void*) conversions
  wifi: rsi: rsi_91x_sdio: Remove unnecessary (void*) conversions
  wifi: rsi: rsi_91x_sdio_ops: Remove unnecessary (void*) conversions
  wifi: rsi: rsi_91x_usb: Remove unnecessary (void*) conversions
  wifi: rsi: rsi_91x_usb_ops: Remove unnecessary (void*) conversions

 drivers/net/wireless/rsi/rsi_91x_coex.c     | 11 +++---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |  3 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c      |  2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  4 +--
 drivers/net/wireless/rsi/rsi_91x_main.c     |  4 +--
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 39 ++++++++-------------
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 15 +++-----
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 20 +++++------
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  2 +-
 9 files changed, 40 insertions(+), 60 deletions(-)

-- 
2.30.2

