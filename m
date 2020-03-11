Return-Path: <SRS0=yqm1=44=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31CDC18E5A
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Mar 2020 09:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5C4C2146E
	for <linux-wireless@archiver.kernel.org>; Wed, 11 Mar 2020 09:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgCKJX4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 11 Mar 2020 05:23:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45512 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgCKJX4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Mar 2020 05:23:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jBx7r-000qTG-Hm; Wed, 11 Mar 2020 09:54:03 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-03-11
Date:   Wed, 11 Mar 2020 09:53:54 +0100
Message-Id: <20200311085355.8235-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

I have a few fixes still; please pull and let me know
if there's any problem.

Thanks,
johannes



The following changes since commit 2165fdf4bc2d323ec73e5995510f163163ce0fa4:

  Merge branch 's390-qeth-fixes' (2020-03-10 16:07:49 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-03-11

for you to fetch changes up to ba32679cac50c38fdf488296f96b1f3175532b8e:

  mac80211: Do not send mesh HWMP PREQ if HWMP is disabled (2020-03-11 09:04:14 +0100)

----------------------------------------------------------------
A couple of fixes:
 * three netlink validation fixes
 * a mesh path selection fix

----------------------------------------------------------------
Jakub Kicinski (3):
      nl80211: add missing attribute validation for critical protocol indication
      nl80211: add missing attribute validation for beacon report scanning
      nl80211: add missing attribute validation for channel switch

Nicolas Cavallari (1):
      mac80211: Do not send mesh HWMP PREQ if HWMP is disabled

 net/mac80211/mesh_hwmp.c | 3 ++-
 net/wireless/nl80211.c   | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

