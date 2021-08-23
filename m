Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF2BC432BE
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Aug 2021 11:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5DE2613A5
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Aug 2021 11:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbhHWLBN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Aug 2021 07:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236339AbhHWLA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Aug 2021 07:00:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 21D0E613CE;
        Mon, 23 Aug 2021 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629716408;
        bh=lc1Im8wSSH2obJkNnm9ge+Xx0A3EIz4JQmwso97pPa8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XuEiMCU+yb4Or0NtGl5C9Sl6X9OnYfu4VnW+oi6CNyji2Aj7vTJYP4gbRswh5ya8l
         IAh1iEuD8EgbdsNjR5vkdYutRcrAFUOAaB4wgXHBUuRbZ/istS4PccaIV5lTIBDDYa
         dLgmgu04X7JqY4vQ0alb288UjZWxoPoYAXIao5wEvjgetgO9B5aSDL0cN7F+kyfhdw
         F/HDlZVE9/2tUYnTFPxyNoB4xzzG+r4eddHUcgnOcZfGLEbTGlvKTi+6prKPsr0x15
         LYIHl1EV2yDHzOBGfkEQiGR6VV8Kdrqf6tXva21F5Clv0gu4YRt+MdKXXojrTzdzO4
         lSxsqAs06o8Gw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qtnfmac: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971640809.3591.9339770206982762794.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:00:08 +0000
References: <de7727a8aec3a3e3fae2218a05bdf3c5949b8150.1629618169.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <de7727a8aec3a3e3fae2218a05bdf3c5949b8150.1629618169.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     imitsyanko@quantenna.com, geomatsi@gmail.com, davem@davemloft.net,
        kvalo@codeaurora.org, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 09:44:07 +0200 you wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below.
> 
> It has been compile tested.
> 
> 
> [...]

Here is the summary with links:
  - qtnfmac: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/06e1359cc83b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


