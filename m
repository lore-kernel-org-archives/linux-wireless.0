Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D93C433DB
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Dec 2020 03:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B67B223E4
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Dec 2020 03:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgLWDus (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Dec 2020 22:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbgLWDus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Dec 2020 22:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B9FE7223E8;
        Wed, 23 Dec 2020 03:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608695407;
        bh=68YIAocpAegvJarZSQkOD4cnGMaKrBeBemQS7jDpLMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V/bLbmVyULUTh1+0FCW8Uk6LpWbhfUz1jXd8N/SQmktK3SR75DWwekVLpXrTtY0Sk
         TtxQOQaoOUwCcwjmV8aG9xItJv/ykqdV8G195HZbgsY/KQ6UccA1WT9V0Wy1/+TZMG
         80K/dUxRG1RbQugUrI6Rlzj+lw2SUR1tZU0ZlGd4KdCXC4KsXUmcoN8skMg7cOY/sm
         Ik9GGdGs9ItCfq6G2cqhg0W1A/1qL2LEUvWgYoiYftQZabuldByQ7kc35/kk/bogqS
         STg4F0D2Q+FpHzo+tj821pU7dTn3m3+ZXvHKIJQOiA4wg6lpcs7FaqKX1JRnOSk2KU
         XYuAAin40VcQA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2020-12-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160869540770.24460.3222068973861028264.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Dec 2020 03:50:07 +0000
References: <20201222163727.D4336C433C6@smtp.codeaurora.org>
In-Reply-To: <20201222163727.D4336C433C6@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue, 22 Dec 2020 16:37:27 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2020-12-22
    https://git.kernel.org/netdev/net/c/e77c725a445a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


