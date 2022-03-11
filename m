Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFB9C433FE
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Mar 2022 22:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiCKWqa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Mar 2022 17:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiCKWqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Mar 2022 17:46:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F6524BE3;
        Fri, 11 Mar 2022 14:37:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 303E5B82D77;
        Fri, 11 Mar 2022 21:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC08CC340EC;
        Fri, 11 Mar 2022 21:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647033630;
        bh=ObrT95bkb2Cky2VCNV5u4Py2J+w7ipygxywBs6x4QDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QlZUiB7kz1PUczh8lHz/26IoTVkqeCauz/r7xjXGHa3MURsJ3TsOowGbqYEuR2Yn+
         /jcl8x6n4Lrv0ei2uhAsucP5q1SYPqWsLG8Km0RsRsY4T6Zke48jRjrtCzzIfpTxEN
         kJnwQABhEUrJPHUl2E9npIzbPEerz16Y+VurD9Yo4bN4SWBz4qRczWcyMDctFxj/Yq
         IZtyNQ4MFWW9HfbQc7d3V2OxSxt4vzvFPk0UDacxD8JpTMntKzINPuViVhWCz8dXyM
         ux5DwE1SwMzwfq7ABj5efm/pJlr1hMhtxLIatZSbdDiXC1LwS8HFG4sZGhNG218ZVo
         T2fDm1/d8mcnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8D1EEAC095;
        Fri, 11 Mar 2022 21:20:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-03-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 21:20:29 +0000
References: <20220311124029.213470-1-johannes@sipsolutions.net>
In-Reply-To: <20220311124029.213470-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 11 Mar 2022 13:40:28 +0100 you wrote:
> Hi,
> 
> Here's another (almost certainly final for 5.8) set of
> patches for net-next.
> 
> Note that there's a minor merge conflict - Stephen already
> noticed it and resolved it here:
> https://lore.kernel.org/linux-wireless/20220217110903.7f58acae@canb.auug.org.au/
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-03-11
    https://git.kernel.org/netdev/net-next/c/0b3660695e80

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


