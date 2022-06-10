Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23582C43334
	for <linux-wireless@archiver.kernel.org>; Fri, 10 Jun 2022 16:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350002AbiFJQux (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 10 Jun 2022 12:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349863AbiFJQuT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Jun 2022 12:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF5113DF0;
        Fri, 10 Jun 2022 09:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FD80B83633;
        Fri, 10 Jun 2022 16:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E20EEC3411C;
        Fri, 10 Jun 2022 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654879815;
        bh=DHGdLXQymDUkfuzsH8FNnURt5aYrSl95UOTWiM0xay8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C0lQUdgB1113bM+uXOqDnAt8q2wc6JCNJCuA2BaUw3XWyuXt6SkD9EqxLK4yk2ekc
         ibumZyt1XVyfCWO8CBZvh7eL9bv8ZLtXiwdwVi+OoAwfFje3uzsA+Ez4p2In9oLL1P
         hk5E8yvV559xS0qaJBlo6PH4KyBLoMzRVaHirJ6KVN4/tbr2U0VyDDMrxk6xhuCezJ
         KrBisSe7dyMaf+A19AhhG1fYmV8RnfMKRiwX15DFtBnzVFZCS2/3IFFcmxlGDffmhp
         CD9EIYMkvggRlle15aoAmZBzz9vwBSzrqLDc/hVyy2Z+HUubT9qCnl6Qwqhjrpq+dA
         WjToXwAZST8UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9D4EE737F0;
        Fri, 10 Jun 2022 16:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-06-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165487981582.13163.11390208834949494930.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 16:50:15 +0000
References: <20220610142838.330862-1-johannes@sipsolutions.net>
In-Reply-To: <20220610142838.330862-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Jun 2022 16:28:37 +0200 you wrote:
> Hi,
> 
> A first set of -next material. As I mention in the tag below
> as well, this is mostly to align/flush, so we can start adding
> MLD work that would otherwise have some conflicts.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-06-10
    https://git.kernel.org/netdev/net-next/c/b97dcb85750b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


