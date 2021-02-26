Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C161C433DB
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Feb 2021 23:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40DFF64E4E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Feb 2021 23:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBZXUu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Feb 2021 18:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhBZXUt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Feb 2021 18:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 071E364EF0;
        Fri, 26 Feb 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614381609;
        bh=QksqskGUkMvHUQIKJEolQWLsuCwmDKwE85wVKBA4snE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jfbk9EDMmwddtZm2B2hohgVuu2wF2si2ijrRJNj8AbBehyQ4zKIO/PWCVCsg5ZsqK
         CpOxbyYI/edqUFf7XkiXkwj34bHOG4Ewee2M0S6m/ucAj+6TXKUUzz2FjVCVe+jFni
         9rNIGcLdGdtF2yvPPvJAaa/PGYg5wmyZ5PAto7f2afesfXWCzWIj3LVDjOPohicDG2
         GNACLKv9r4i+ov5RubWNM3J38j3mIdrhOonwniARxzl7GFvWZc//t+4h3tm3AVC8tz
         23AFFbuxPGXZjyrVCORky5yr+XGP/ibEQ2+T1DvYLD9GNUaTU8JPcVm5xle7F7zYPm
         a8k1b/h/SP85w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-02-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161438160894.18491.5701850193914012065.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Feb 2021 23:20:08 +0000
References: <20210226164411.CDD03C433CA@smtp.codeaurora.org>
In-Reply-To: <20210226164411.CDD03C433CA@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Fri, 26 Feb 2021 16:44:11 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-02-26
    https://git.kernel.org/netdev/net/c/0d1bf7a5e225

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


