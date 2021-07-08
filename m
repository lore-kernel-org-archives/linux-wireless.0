Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3DAC07E96
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Jul 2021 20:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B39CF61878
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Jul 2021 20:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhGHUmr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Jul 2021 16:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230461AbhGHUmq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jul 2021 16:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 32BEA616E9;
        Thu,  8 Jul 2021 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625776804;
        bh=+5neBRC3/ETp/zdUfgyRaV6iyujCORLImXx5nfaB2ag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kuc0VWlqirRzd32TEuGkew1Q/GwXjWstMEpmJcChNqvVisRGqIbvT5lEG6xCmXiW4
         wggIkxfG5+N5j3sJ2lNPOB8LVdEt5T3cyzkbsHIdFuyy+PDpIWfFH3DotoYMp5rpiG
         GKkLn/jOHIiXJaAWFBYV1CqSnqzCL1WDfLXk4UjdBQpBmXwzi4/aG60r27Y0poIRR2
         OPPSueoa/VZCIYhzH1VTt1Do+h3Ka90WKqQKBK+N/KBfO9np93jn7SKQwJqHldQEJl
         xp1A1ra//y1GAx3HrSmFSBRfdD0jsZcwWjIXlGdeoSdmJUW6OlbDMOg3/KEvvzc17D
         BXUZlQs0DHyEg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mt76: mt7921: continue to probe driver when fw already
 downloaded
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162577680412.12322.7727150066013328820.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Jul 2021 20:40:04 +0000
References: <20210708131710.695595-1-aaron.ma@canonical.com>
In-Reply-To: <20210708131710.695595-1-aaron.ma@canonical.com>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, sean.wang@mediatek.com,
        Soul.Huang@mediatek.com, deren.wu@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Jul 2021 21:17:10 +0800 you wrote:
> When reboot system, no power cycles, firmware is already downloaded,
> return -EIO will break driver as error:
> mt7921e: probe of 0000:03:00.0 failed with error -5
> 
> Skip firmware download and continue to probe.
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> 
> [...]

Here is the summary with links:
  - mt76: mt7921: continue to probe driver when fw already downloaded
    https://git.kernel.org/netdev/net/c/c34269041185

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


