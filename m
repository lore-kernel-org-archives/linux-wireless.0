Return-Path: <SRS0=mEur=BK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9217BC433DF
	for <linux-wireless@archiver.kernel.org>; Fri, 31 Jul 2020 07:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79172207F5
	for <linux-wireless@archiver.kernel.org>; Fri, 31 Jul 2020 07:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbgGaHWi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 31 Jul 2020 03:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731587AbgGaHWi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Jul 2020 03:22:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EFEC061574;
        Fri, 31 Jul 2020 00:22:38 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k1PND-00Dyrq-AD; Fri, 31 Jul 2020 09:22:35 +0200
Message-ID: <5e6f863980ecb77ef42b5bce31e1d91fb4f62506.camel@sipsolutions.net>
Subject: Re: linux-next: Fixes tag needs some work in the mac80211-next tree
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        P Praneesh <ppranees@codeaurora.org>
Date:   Fri, 31 Jul 2020 09:22:34 +0200
In-Reply-To: <20200731082105.75e60bda@canb.auug.org.au>
References: <20200731082105.75e60bda@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2020-07-31 at 08:21 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>   5fa4ab3cf34e ("mac80211: avoid bss color setting in non-HE modes")
> 
> Fixes tag
> 
>   Fixes: eb024f1abca3("mac80211: avoid bss color setting in non-he mode")
> 
> has these problem(s):
> 
>   - Target SHA1 does not exist
> 
> I can't find which commit is meant.

Huh, yeah. I'll go fix that.

Thanks!

johannes

