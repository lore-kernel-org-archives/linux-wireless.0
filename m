Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D1AC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3ECF720675
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfDZJIB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:08:01 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53824 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfDZJIB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 05:08:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJwpq-00074v-76; Fri, 26 Apr 2019 11:07:58 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-04-26
Date:   Fri, 26 Apr 2019 11:07:46 +0200
Message-Id: <20190426090747.20949-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

Just have a few more stragglers, looks like things have quieted down.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit c03fd0171ba6c8807ff5ba7c797896c84e18f3bc:

  Merge tag 'mac80211-for-davem-2019-04-09' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211 (2019-04-09 10:57:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-04-26

for you to fetch changes up to 517879147493a5e1df6b89a50f708f1133fcaddb:

  mac80211: don't attempt to rename ERR_PTR() debugfs dirs (2019-04-23 13:47:05 +0200)

----------------------------------------------------------------
 * fix use-after-free in mac80211 TXQs
 * fix RX STBC byte order
 * fix debugfs rename crashing due to ERR_PTR()
 * fix missing regulatory notification

----------------------------------------------------------------
Bhagavathi Perumal S (1):
      mac80211: Fix kernel panic due to use of txq after free

Johannes Berg (2):
      mac80211: fix RX STBC override byte order
      mac80211: don't attempt to rename ERR_PTR() debugfs dirs

Sriram R (1):
      cfg80211: Notify previous user request during self managed wiphy registration

 net/mac80211/debugfs_netdev.c | 2 +-
 net/mac80211/ht.c             | 5 +++--
 net/mac80211/iface.c          | 3 +++
 net/wireless/reg.c            | 5 ++---
 4 files changed, 9 insertions(+), 6 deletions(-)

