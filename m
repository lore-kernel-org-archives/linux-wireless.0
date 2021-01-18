Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A4DC433DB
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Jan 2021 22:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EBB422228
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Jan 2021 22:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390593AbhARWvH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:51:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732477AbhARWut (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jan 2021 17:50:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 20FBD2222A;
        Mon, 18 Jan 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611010209;
        bh=zuWfpZ4hjw9/aPWqTVav9cTSi55/kKdgu1hpodVrMsQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G5046WrjbqMb8EvKA8GAjn1qSUPYhHkLCOjXN0YirZ6Nh4y7Qd5NyT0nOvR2q2dRY
         4moRr3Q2aNElk4wW+rRs/50LHd+7674btcx56qsFdFp+3rBypERMG5xsmhdmbqOuuj
         8sB5lONBGBELEDJsU7ZfFQXtuAKEBUgWj28CeDX9riyky1wZ7Mxb3/MhvStt4auh8+
         CRiCuZdF5P2FIxb+JqcIVvw9v3X04X+qwzUWjqsUvv1MWhP/4RyOY1QMP6fl0tFFRE
         rVvZuTjQp5NGAZaHAlVFYvtYWxRkE3T/gMdovOw4m+/rZAXzB1KkAMILR5gCNv9LEB
         olQZuLaRtORew==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-01-18.2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161101020906.2232.13826999223880000897.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jan 2021 22:50:09 +0000
References: <20210118204750.7243-1-johannes@sipsolutions.net>
In-Reply-To: <20210118204750.7243-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Mon, 18 Jan 2021 21:47:49 +0100 you wrote:
> Hi,
> 
> New try, dropped the 160 MHz CSA patch for now that has the sparse
> issue since people are waiting for the kernel-doc fixes.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-01-18.2
    https://git.kernel.org/netdev/net/c/bde2c0af6141

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


