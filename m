Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAB0C47080
	for <linux-wireless@archiver.kernel.org>; Mon, 31 May 2021 20:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 329D661159
	for <linux-wireless@archiver.kernel.org>; Mon, 31 May 2021 20:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhEaUdF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 31 May 2021 16:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbhEaUct (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 May 2021 16:32:49 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F66C061574;
        Mon, 31 May 2021 13:30:30 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnoYO-000F87-M7; Mon, 31 May 2021 22:30:28 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v4.9 00/10] wireless security fixes backports
Date:   Mon, 31 May 2021 22:30:11 +0200
Message-Id: <20210531203021.180010-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

One or two of the patches here were already applied since they
applied cleanly, but I'm resending the whole set for review now
anyway.

johannes



