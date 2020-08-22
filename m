Return-Path: <SRS0=4i1v=CA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4569FC433DF
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Aug 2020 23:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F602080D
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Aug 2020 23:20:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gm/UUnuY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgHVXUF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Aug 2020 19:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgHVXUC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Aug 2020 19:20:02 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D53C061573;
        Sat, 22 Aug 2020 16:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=csQurTZyvfQDdDaT5jrS6ZrOX/zsulP2EHMLBxER/0s=; b=Gm/UUnuY7V40W3rqWBPhySR34c
        ujWxmUXRJzlLN3IlRL8m9HMtUX7pSubEga25ho/SdiQsWxpen6n2pM48S+76TtHEghR9zdbJShOmw
        flgJ8dd0+v24m5/TrElTLa/mIdLvXmboI0CUA9gh3keXwukaYw/M5kuK8EIyBarZ2/pEWw63y7ZBy
        o/Ua2oowcRSWx0mCOp4kjLGKkRRyQejH8YgfqY4zU6o59KO3AfStsYZhPXg+sxPrqR8U636CVYSvQ
        KcKS46Lw+VBKfHHWkiBNsD4/3c9yZGzvP6xivdLGfjWnvTjvg+rAQ8A/jL0mw06G6UFstTrltcJR0
        FfHLfj2w==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9cnl-0006fS-GZ; Sat, 22 Aug 2020 23:19:58 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] net: wireless: delete duplicated words + other fixes
Date:   Sat, 22 Aug 2020 16:19:46 -0700
Message-Id: <20200822231953.465-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Drop or fix duplicated words in net/wireless/ and net/mac80211/.

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org


 net/mac80211/agg-rx.c      |    2 +-
 net/mac80211/mesh.c        |    2 +-
 net/wireless/core.h        |    4 ++--
 net/wireless/reg.c         |    4 ++--
 net/wireless/scan.c        |    4 ++--
 net/wireless/sme.c         |    2 +-
 net/wireless/wext-compat.c |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)
