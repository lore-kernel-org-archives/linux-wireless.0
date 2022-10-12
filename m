Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09611C4332F
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Oct 2022 02:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiJLCUV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Oct 2022 22:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJLCUT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2022 22:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FE93DBD6;
        Tue, 11 Oct 2022 19:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 284D3B818D6;
        Wed, 12 Oct 2022 02:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFB3BC433C1;
        Wed, 12 Oct 2022 02:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665541215;
        bh=EpzUM2vwkZhMcsHia2+zDibYNKBzgLioWsFR4KLKMzA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=alTOlwqZNc/W0riduTIgN/Jq2xJn1/fAbdFHYwIGkwiQHre7p3oe8LNsDCwYxbY1Y
         YzdjmZtQFUyFKH5rrOX8QvRcaEePia1dWxXoN1RqrTjmeElXl94AiCEoHDDSlOqYPx
         sdRfU5DMpsnq13+4y/QA69EVdmnCCdXjk3tuPbSVxn4LFRdJP/19pkbCFTi61aLLwd
         DUVcLRZZoi5qWTIH0BQrTTnnR8Udo5ogQU3xBIeSMufArG6FQH0mF2vKREVJ/LI/3C
         NlJxpzYGLKOIxTBFWRay795vE7ftiUAKJkKKWi/zP6vzrbTF3/Q4zK9R9JivODm08s
         okQB6nrbp7qzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A68BEE29F31;
        Wed, 12 Oct 2022 02:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-10-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166554121567.17120.8682724814876111228.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Oct 2022 02:20:15 +0000
References: <20221011163123.A093CC433D6@smtp.kernel.org>
In-Reply-To: <20221011163123.A093CC433D6@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 11 Oct 2022 16:31:23 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-10-11
    https://git.kernel.org/netdev/net/c/72da9dc22ff3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


