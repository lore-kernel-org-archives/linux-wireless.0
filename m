Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E62E94139
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Oct 2023 23:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbjJFXbG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Oct 2023 19:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbjJFXbF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2023 19:31:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B03893
        for <linux-wireless@vger.kernel.org>; Fri,  6 Oct 2023 16:31:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14E3FC433C7;
        Fri,  6 Oct 2023 23:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696635064;
        bh=DdEPyzY8UjDo3W+qDn1Sz+TgpUNnKg0AUDgsg+eGL2g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tgM5uSEx4Ti/AJs122v49BsTP80Lmm1lC7aEk6gWjgBIPtUlcB0l4IP2iz27Vl1TC
         bcJMu9GFUxcSWPcN/BAyUew9wBCqVrcasITrNYO9UEcOQzbHOTy/X7Jv06lBHTgHSZ
         4RdSrZ3JnrJSFztutRapnbSWJxIoD1Av8pB5iLb2Ten9iWpQUU6BxaISR5i7R6Zevc
         6SbfUTDzMlnz7Eu4aMnuoijrE0onLj/ltQz+FBGhoMM3ZZkLt7IfXPKRs0GDbsdbJd
         M72+jG5aXw0aTU30MlZKSswQx2IjhIZnHAzug69lej281a0h5V+QqmfGE5CKIsVADz
         NpNhbcSJXtMvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE4B4E632D2;
        Fri,  6 Oct 2023 23:31:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2023-10-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169663506396.14259.17929866398775888739.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Oct 2023 23:31:03 +0000
References: <87jzrz6bvw.fsf@kernel.org>
In-Reply-To: <87jzrz6bvw.fsf@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 06 Oct 2023 17:53:07 +0300 you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2023-10-06
    https://git.kernel.org/netdev/net-next/c/a1fb841f9d18

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


