Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DA3C48BCF
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jun 2021 22:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0A49613F0
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jun 2021 22:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhFIWCV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jun 2021 18:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229942AbhFIWCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jun 2021 18:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CD462613E1;
        Wed,  9 Jun 2021 22:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623276025;
        bh=7attH/TeAB28fCUKe6JAND/YMfKDuqiGqkd7Ab6Xv0k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zcf0bcE+sTmoaJZb3gCDRvwUWpa34LA9BrwHMfIH2dX2f6BrzxclRoMP9fW1Ih00b
         0dSMZOCe+3H7QVrPvYOJBh0bTW9tzcN4OPk0Ri3lLVNeoINaGF3KveeDVGWvhYVRWX
         LyXLJO3jlLVKqEi7PWbCBU1PLGaK++nKxfECH6KdSHsb53mqQtD1Y0zFMDVsNOVYy9
         3q1HfhLA4KMhSwkQWSB0WeNZEaFTByma5auxAsW13hHgh9lvfYWCBDkczWbRZsx0xi
         VQLRi7ViKJEO1zgyB6By61+eNW/8tVt/QmTHif99b9eqaoCPq1c2omvNh1EHy6FXpD
         GY2o4LdJvtH2g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-06-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327602579.7324.16342817883327528118.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:00:25 +0000
References: <20210609144243.97486-1-johannes@sipsolutions.net>
In-Reply-To: <20210609144243.97486-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed,  9 Jun 2021 16:42:42 +0200 you wrote:
> Hi,
> 
> The last pull request I sent was coordinated with only
> those CVE fixes - now I have accumulated more fixes,
> many of them actually locking fixes for the RTNL redux.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-06-09
    https://git.kernel.org/netdev/net/c/93124d4a90ba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


