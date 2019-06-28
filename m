Return-Path: <SRS0=Fjak=U3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFBAC5B57A
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jun 2019 14:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A362086D
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jun 2019 14:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfF1Ooy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Jun 2019 10:44:54 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52850 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfF1Ooy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jun 2019 10:44:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hgs7N-0003p4-Gb; Fri, 28 Jun 2019 16:44:49 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-06-28
Date:   Fri, 28 Jun 2019 16:44:43 +0200
Message-Id: <20190628144444.25092-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Just a single patch still for the current RC cycle, I debated
whether to send a pull request at all or just ask you to apply
the patch, but did it this way now.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 556e2f6020bf90f63c5dd65e9a2254be6db3185b:

  Merge tag 'clk-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux (2019-06-28 08:50:09 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-06-28

for you to fetch changes up to d2ce8d6bfcfed014fd281e06c9b1d4638ddf3f1e:

  nl80211: Fix undefined behavior in bit shift (2019-06-28 16:07:54 +0200)

----------------------------------------------------------------
Just a single patch:
 * 1<<31 is undefined, use 1U<<31 in nl80211.h UAPI

----------------------------------------------------------------
Jiunn Chang (1):
      nl80211: Fix undefined behavior in bit shift

 include/uapi/linux/nl80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

