Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC701C433E0
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Jan 2021 05:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8D9207B1
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Jan 2021 05:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbhAZF5R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:57:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732170AbhAZDku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jan 2021 22:40:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2318D22573;
        Tue, 26 Jan 2021 03:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611632410;
        bh=NlKi9N+au3dy7yGv+/2Eh21ZybaC8UDV4q1G0xWwOm0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ua+G0UOD7RDSDWKU0lttTqknLCutfMqGeR6XxOtX5PgXmEJe4bxQIMsMr8kYth383
         tZ3aZ+Df0eEQNyYIELasOLWl/UATWszojQPB9SvqPfxIAN9Vj35cEYgcSiBAW8wGyZ
         tQXDqyEecOY28Yj5++0KH3VgeCxmqpdmkFR+KiPHgTq12KwbvbUlXqRQaqehwLD7Tx
         KFxvvTZB5nOkoTv2XpONlbtTYVc+CS35bacrjoRjx+sbztDhG9ZvEbV/u+s7vZmwo4
         /cq8K+IVkp+gIsDbOgTe7rUczDMzV2VO14m8ZHlIEVEPUtLXdw8ZL9v347MUEGciWM
         eJcWzw+l6TsQg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: fix typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161163241006.10294.3087696077616981319.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jan 2021 03:40:10 +0000
References: <20210123082550.3748-1-samirweng1979@163.com>
In-Reply-To: <20210123082550.3748-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     mgreer@animalcreek.com, linux-nfc@lists.01.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wengjianfeng@yulong.com
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 23 Jan 2021 16:25:50 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> change 'regster' to 'register'
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/trf7970a.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - nfc: fix typo
    https://git.kernel.org/netdev/net-next/c/02c26940908f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


