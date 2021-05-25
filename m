Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2451C2B9F8
	for <linux-wireless@archiver.kernel.org>; Tue, 25 May 2021 11:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D06296140A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 May 2021 11:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhEYLOk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 May 2021 07:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbhEYLOj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 May 2021 07:14:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3577AC061574;
        Tue, 25 May 2021 04:13:00 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1llUzO-00EMeA-63; Tue, 25 May 2021 13:12:46 +0200
Message-ID: <8d0cc8941fdefa19e59651202443f1d50f2542a2.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Fix inconsistent indenting
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 25 May 2021 13:12:45 +0200
In-Reply-To: <1621940233-70879-1-git-send-email-jiapeng.chong@linux.alibaba.com> (sfid-20210525_125729_917249_DCBAF50D)
References: <1621940233-70879-1-git-send-email-jiapeng.chong@linux.alibaba.com>
         (sfid-20210525_125729_917249_DCBAF50D)
Content-Type: text/plain
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wrong subject - this isn't related to cfg80211, it's ath6kl.

johannes

