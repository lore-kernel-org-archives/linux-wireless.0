Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216B9C433B4
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Apr 2021 21:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F23BB6128E
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Apr 2021 21:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243057AbhDMVkd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Apr 2021 17:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232646AbhDMVkd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Apr 2021 17:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1676613C1;
        Tue, 13 Apr 2021 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618350012;
        bh=vsJwV1TqBOc8SjTLWkjWYnrEngpn+yQaSOO7SM/DTJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sjnClO4VP81wddgU+pnxPT89Kdje5MzGsdjusvK9tKfQBcJpaATjkEPDjtB7KykX0
         LCmDfjQT7TkABODDjzkSQYVhAL1ISTX42LUtJ18ns7RHPQcPd3Fj5qwxIALjM7GwiW
         ZVjniEvxRYAAZj90wZrDovQpg+OA9ZE9v7I9pDW3tAWvMYSgBFrSMMFshh+1hyER/n
         RiyEZRGYNm41n5ehJWyVkxGQ4sXngf0J77lSpBpbE2CPOe9YMx5CBnoICCXCOFZ+Lt
         ZaSA502dVSyqluNvORMrl84JUY+vx5YHBmHAlZnqs4u5NRg0HBYrvAu0mVxOZ5t7D3
         D7OKjMs+vX0/Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-04-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835001271.18297.6600658216026899811.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 21:40:12 +0000
References: <20210413053345.0D53FC433ED@smtp.codeaurora.org>
In-Reply-To: <20210413053345.0D53FC433ED@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 05:33:45 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-04-13
    https://git.kernel.org/netdev/net-next/c/5fff4c14ae01

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


