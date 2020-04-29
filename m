Return-Path: <SRS0=wwyj=6N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D10C83006
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Apr 2020 13:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 723062074A
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Apr 2020 13:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgD2Ns6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 Apr 2020 09:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgD2Ns6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Apr 2020 09:48:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FE3C03C1AD;
        Wed, 29 Apr 2020 06:48:57 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jTn54-001vkM-VA; Wed, 29 Apr 2020 15:48:55 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <ordex@autistici.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] netlink validation improvements/refactoring
Date:   Wed, 29 Apr 2020 15:48:36 +0200
Message-Id: <20200429134843.42224-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Sorry - again, I got distracted/interrupted before I could send this.
I made this a little more than a year ago, and then forgot it. Antonio
asked me something a couple of weeks ago, and that reminded me of this
so I'm finally sending it out now (rebased & adjusted).

Basically this just does some refactoring & improvements for range
validation, leading up to a patch to expose the policy to userspace,
which I'll send separately as RFC for now.

johannes


