Return-Path: <SRS0=xK5X=SX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BB2C10F14
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Apr 2019 09:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 406742080D
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Apr 2019 09:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbfDUJVY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 21 Apr 2019 05:21:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:26174 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfDUJVY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Apr 2019 05:21:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Apr 2019 02:21:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,377,1549958400"; 
   d="scan'208";a="339373164"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.48])
  by fmsmga006.fm.intel.com with ESMTP; 21 Apr 2019 02:21:22 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        linux-wireless@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 0/2] nfc: compilation cleanups
Date:   Sun, 21 Apr 2019 12:12:34 +0300
Message-Id: <20190421091236.19168-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Two compilation cleanups.

Tomas Winkler (2):
  nfc/pn544: fix inconsistent indenting
  nfc/microread: use correct casting in microread_target_discovered()

 drivers/nfc/microread/microread.c | 6 +++---
 drivers/nfc/pn544/pn544.c         | 7 ++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.20.1

