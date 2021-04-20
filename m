Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA2CC433ED
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Apr 2021 23:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AE9461405
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Apr 2021 23:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhDTXus (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Apr 2021 19:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233992AbhDTXup (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Apr 2021 19:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1DC161405;
        Tue, 20 Apr 2021 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618962612;
        bh=3I4pUI7rCMOG3Da0kV2d/f8WaZp3liBd8EYbJlzZkH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VVLevUqaKSq4GkfwfDPCxI/tya9ps2hTExfMhLpXovX7eQaIS/1NnJFE8Cu0dz9of
         rC4+UKiCRFx1Jx5REW93YL/zRoIu7t9Q724RwJoWmJOovMED7VLLJkFphIowpecZWg
         Z8Pu7GNg+1JRaypp7ltb5DSlP2F3TPzMVrmlU35o+1vZqUH/7mj4xpWjJCXWd5vmXw
         hX3CDTzX9AYbVTMe3UXTk6gmw3bK63J2y4h/MGh89wZ/j3RjrT82HzVaosjgXeTGIO
         w9AUMbJfpVqtW1iZFwBou7h/+u3W+KGAYCHpubiXHEld0maySVaYdMosIQV/broHKC
         zWwKGC2anfjkw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211-next 2021-04-20
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896261275.30983.14370375251925432162.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Apr 2021 23:50:12 +0000
References: <20210420150031.24514-1-johannes@sipsolutions.net>
In-Reply-To: <20210420150031.24514-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 17:00:30 +0200 you wrote:
> Hi,
> 
> We have a bunch more things for next, now that we got another
> week "for free" ;-) Pretty much all over the map, see the tag
> description and shortlog below.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211-next 2021-04-20
    https://git.kernel.org/netdev/net-next/c/08322284c162

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


