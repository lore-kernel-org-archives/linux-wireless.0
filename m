Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38652C433B4
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Apr 2021 19:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0847861042
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Apr 2021 19:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbhDIT2w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Apr 2021 15:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbhDIT2o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Apr 2021 15:28:44 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C8CC061763
        for <linux-wireless@vger.kernel.org>; Fri,  9 Apr 2021 12:28:29 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lUwnq-009aPy-Ud; Fri, 09 Apr 2021 21:28:27 +0200
Message-ID: <c39d5ac8ce9e1a8079e8ed83c1a05c3abbf54254.camel@sipsolutions.net>
Subject: Re: [PATCH v9 0/4] Multiple BSSID support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aloka Dixit <alokad@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 09 Apr 2021 21:28:26 +0200
In-Reply-To: <2427e22bdd9e34aec0667a78dd8d6537@codeaurora.org>
References: <20210310182604.8858-1-alokad@codeaurora.org>
         (sfid-20210310_192727_681722_4BC25758) <cb1325ad538c3bf385b5bdadf03cfbf9f4afa390.camel@sipsolutions.net>
         <2427e22bdd9e34aec0667a78dd8d6537@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2021-04-09 at 11:31 -0700, Aloka Dixit wrote:
> 
> BTW, do you see value in replacing all occurrences
> of *_multiple_bssid_* with *_mbssid_* (also in new
> nl80211 attributes).
> Most lines needed to be split because of 80 character
> boundary, so this replacement will make that code
> look cleaner. I have avoided it till now to reduce
> number of changes between versions.

Might be nicer, but I can live with the longer identifiers too. I don't
really mind if you do it between versions though, so feel free.

johannes

