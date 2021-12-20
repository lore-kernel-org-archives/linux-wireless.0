Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501ADC433EF
	for <linux-wireless@archiver.kernel.org>; Mon, 20 Dec 2021 12:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhLTMd0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 20 Dec 2021 07:33:26 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51526 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229596AbhLTMd0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Dec 2021 07:33:26 -0500
Received: from 91-156-5-105.elisa-laajakaista.fi ([91.156.5.105] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <luca@coelho.fi>)
        id 1mzHqy-001OhV-CU; Mon, 20 Dec 2021 14:33:24 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@kernel.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Mon, 20 Dec 2021 14:33:16 +0200
Message-Id: <20211220123318.345841-1-luca@coelho.fi>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/2] iwlwifi: updates intended for v5.17 2021-12-20
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Here's the eighth set of patches intended for v5.17.  This is a small
one with just to fixes for iwlmei that Emmanuel asked me to send out.
It turned out to be only two, not "a few" as I mentioned before.

The changes are:

* A couple of important fixes in iwlmei.

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.



Emmanuel Grumbach (2):
  iwlwifi: mei: clear the ownership when the driver goes down
  iwlwifi: mei: wait before mapping the shared area

 drivers/net/wireless/intel/iwlwifi/mei/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.34.1

