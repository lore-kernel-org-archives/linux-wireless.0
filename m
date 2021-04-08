Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F1AC433ED
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Apr 2021 11:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BC666113D
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Apr 2021 11:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhDHLJR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Apr 2021 07:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbhDHLJQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Apr 2021 07:09:16 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795F9C061760
        for <linux-wireless@vger.kernel.org>; Thu,  8 Apr 2021 04:09:04 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lUSX0-008yON-PB; Thu, 08 Apr 2021 13:09:02 +0200
Message-ID: <15f53358376d388c70bad2f0ee098768293e5a5b.camel@sipsolutions.net>
Subject: Re: [PATCH] iw: Add HE UL MU fixed rate setting
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Muna Sinada <msinada@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 08 Apr 2021 13:09:02 +0200
In-Reply-To: <1615313767-13017-1-git-send-email-msinada@codeaurora.org>
References: <1615313767-13017-1-git-send-email-msinada@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2021-03-09 at 10:16 -0800, Muna Sinada wrote:
> Adding mcs fixed rate settings for HE UL MU traffic, which encompasses
> both UL-OFDMA and UL-MUMIO.

This patch doesn't apply.

johannes

