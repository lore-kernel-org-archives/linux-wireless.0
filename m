Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 394A8C433F5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Oct 2021 19:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 182E7610C8
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Oct 2021 19:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbhJVTc1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Oct 2021 15:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232029AbhJVTcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Oct 2021 15:32:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F14A60E0C;
        Fri, 22 Oct 2021 19:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634931007;
        bh=rXNdZ6om4algPbKXIBCJVIWoWSyEw5YdXROTczTLvdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s1ZXC14PZquLHgKIeOgMQnEc9bLxS3J6J0zauOpW9bbutbhiR03gYBIW4FHTnQTJw
         09TsJ4N1IOWaVgtXDMbQvUezoEnLLjReQ35C+kU4FMOkaWWJsQWlGmYt11PxsORO7U
         fmzFxkmyT7Nk9gg74p4w7PyzJg1LxsSbntcBUxu1wiYWMEgJt1s8+KmVD/ixxf7eEX
         RwLEjzk9J32xuS0/2iAODW7DRBhh5S9V5zeOYlnVs66tqNrwmpSOmtILFGw1qbf6+X
         NB5VHkwYt2rH9C5hXgcmUzpQFd2yBWXhXi3OZ15BpMaEVYPTXBZSwtf8YQhwOEZz1Q
         f/wyL5YH/QqdQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-10-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163493100739.20489.10617693347363757800.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 19:30:07 +0000
References: <20211021154351.134297-1-johannes@sipsolutions.net>
In-Reply-To: <20211021154351.134297-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Oct 2021 17:43:50 +0200 you wrote:
> Hi,
> 
> So I had two fixes pending in my tree and forgot to send them before
> going on vacation ... at least they've been there for a while now ;)
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-10-21
    https://git.kernel.org/netdev/net/c/7fcb1c950e98

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


