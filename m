Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A110C4167B
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Dec 2022 20:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiLLUaZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Dec 2022 15:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbiLLUaY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2022 15:30:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748C215837;
        Mon, 12 Dec 2022 12:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06C2F61214;
        Mon, 12 Dec 2022 20:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C214C433F0;
        Mon, 12 Dec 2022 20:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670877020;
        bh=ezBkCmQhN4P/me21fhlPnht/P5oZYQ5ye14VOe3W280=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CltFt9NDXz1zvIX3AwZmbftj7Gg47rs/8LfdFSc8urxNhqtX4t3agE0tqlwUfxGov
         qK4R3tnLHfApBXxqJYdXZWdexr/Fa8Un7ke+QalfpfCDq/oB5o1JkM3CNxbBVOVOK9
         inoelLqOz1r6FEx7zHuY8kpgXnWD994DbDlqByUo3cS8eEZES4vM2Vuh0pXzrdbuhV
         RcxwNetPWlCvmQ5BNA6OVhvpr8wlmJZ83cfCuWcmnOEyFLxZv0E1uUw0U66lRZYfYs
         x5ut8sj81zQii1CKCg93Tc12h/ggf4FdrGlB6katZe1tUxrGhi2i6dmVP/XkdYqiWg
         +hQhbg30ORklQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34CCBC00448;
        Mon, 12 Dec 2022 20:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-12-12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087702021.6337.6994775534614645395.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 20:30:20 +0000
References: <20221212093026.5C5AEC433D2@smtp.kernel.org>
In-Reply-To: <20221212093026.5C5AEC433D2@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Dec 2022 09:30:26 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-12-12
    https://git.kernel.org/netdev/net-next/c/fba119cee141

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


