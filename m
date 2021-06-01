Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C3EC47080
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Jun 2021 08:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF979600CD
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Jun 2021 08:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhFAIH2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Jun 2021 04:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbhFAIH0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Jun 2021 04:07:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D31C061574;
        Tue,  1 Jun 2021 01:05:44 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnzPD-000V6C-5W; Tue, 01 Jun 2021 10:05:43 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     m.chetan.kumar@intel.com, loic.poulain@linaro.org
Subject: [RFC 0/4] wwan framework netdev creation
Date:   Tue,  1 Jun 2021 10:05:34 +0200
Message-Id: <20210601080538.71036-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Here's a respin of the series to create netdevs through the WWAN
framework. I haven't tested it at all, since I don't have any
such hardware, so I guess there will be some bugs ... It'd be
best if somebody else takes over here, Loic, maybe I can talk
you into getting the generic bits done if you have a test case? :)

This applies on top of the IOSM driver series posted here:
https://lore.kernel.org/r/20210520140158.10132-1-m.chetan.kumar@intel.com

I've included the first bugfix patch only so it actually all
can apply properly, not really needed for review.

johannes


