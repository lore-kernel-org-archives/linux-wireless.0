Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25512ECAAA3
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Aug 2022 11:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344246AbiHZLK0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Aug 2022 07:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344118AbiHZLKZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2022 07:10:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A6A4D24A;
        Fri, 26 Aug 2022 04:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F0F5B830C7;
        Fri, 26 Aug 2022 11:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E66DC433D7;
        Fri, 26 Aug 2022 11:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661512219;
        bh=YOYp8KtF/qxCDxeS3Gc7Tg13zOF65xSh11wnjWP6kj4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A0SjgADDa9dIjTluI6JUL3FtwhtTVnTHzyAJmVxRvz8JCjk5k+5+5LwrZGKdw8DwJ
         n2eHulJfF2wuWl0MKV4FO/0SH+PF4WL6KrIMKE7hyYSeqvpiIjjz7U1LuHBAF4BTe3
         FvFZZLm6FAo2yTErRoAoxvB/ZGRYamNBASIbD5BuopkfVDXqC3TGFG4X4AKdMFls2T
         gNgvpr3G1xhhJygBftVp8f1l+U2b8Pgsk75d2U3qcjzSkIG8V+Io+hoj70JYd0q+9a
         BKDv+wyHBmcf8g43djRFtbEQM8VNy3AU2Ltd+kmnqZ6oedD6aSClCYBSKAjmsGnhpZ
         pIh/snExBg8Xw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 343E3E2A040;
        Fri, 26 Aug 2022 11:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-08-26-v2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166151221920.17758.15599230326116272592.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Aug 2022 11:10:19 +0000
References: <20220826102118.25148-1-johannes@sipsolutions.net>
In-Reply-To: <20220826102118.25148-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 26 Aug 2022 12:21:17 +0200 you wrote:
> Hi,
> 
> And here's a one for net-next. Nothing major this time
> around either, MLO work continues of course, along with
> various other updates. Drivers are lagging behind a bit,
> but we'll have that sorted out too.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-08-26-v2
    https://git.kernel.org/netdev/net-next/c/643952f3ecac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


