Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C32BC4338F
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Aug 2021 11:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37CFB6136F
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Aug 2021 11:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbhHWLK6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Aug 2021 07:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236301AbhHWLK5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Aug 2021 07:10:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6B13661391;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629717015;
        bh=ig5ptECh8CQ3XDKyUcQf7E6A5jrN37C1+1uDZs38l54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ssWsmMDikjZhWAlZpshwXBgI9zfL9535Eb0RKMoMtrNIlxDJF7dfZw43BuzQe+c8K
         Zxr24jAhhJVjhQoTrSFvPC3aLntH8kReIurvvJ4Uil/4Qgd4OHvpDLBMMXrRzHqFx6
         TOO9yU9XM5L7TQ3vsM+GMUpBtFbnA4OUK0QiSVxu7sXCK4sEhAdCnLqBNI4WNuEmTs
         ULlmZe3Ajs/G4TQ5kwnSsDM2tlSuXw+8jJR7ELFCVOK1+xAnCdJmHC67BjiXx3URug
         abGAJMq71zN6xMf93kTlb1sPWSfvBJhqCXeBRStMYs27GYOPPHjtkc169zy0/zWaWD
         FQvt8Cpk9vhrA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-08-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971701539.8269.8347648767487963500.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:10:15 +0000
References: <20210822085438.360ACC4338F@smtp.codeaurora.org>
In-Reply-To: <20210822085438.360ACC4338F@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 08:54:38 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-08-22
    https://git.kernel.org/netdev/net-next/c/e6a70a02defd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


