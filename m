Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F2DC433DB
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Feb 2021 00:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9019764EA6
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Feb 2021 00:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhBMAu7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Feb 2021 19:50:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229903AbhBMAu7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Feb 2021 19:50:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E071B64E9A;
        Sat, 13 Feb 2021 00:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613177418;
        bh=vZaerVAV497LJvbhjqKmiEU8XeG9c9caPc5C78doXL8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KGjXRzXebZ7QijqWR3d3+SyOgc7Rk4Y+vCZ/LhS8L0aBAkKxnNnFEwwJd1NW2HQwj
         /ffOCp7CAgY5qxGwjfTO9EOW4nnrG41KCGebNKtn7cZEIoT/vw/eMCjQRu1i+PeAhV
         +gFkHvN9wSHaH2e8OFy/uD/xuJnDCIOVDIpnBm9ue0QJ8gyXLkcgTmfu3SqOSZRscU
         zPrN7K6uPTVCPgiSrLWvypBfJ8aODxW8G8WO7np9M60kgoA/gSnTbWYoQEwlmhpUif
         02G+AvyPl7Bif4mXlP1SQuyMrIe7vuX+54OS5UUuPbbrAbmsvKfreCBU2bT+2/y76b
         sgrsa9keQahlg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-02-12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161317741889.7081.17034860236151363021.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 00:50:18 +0000
References: <20210212105933.1F8E7C43461@smtp.codeaurora.org>
In-Reply-To: <20210212105933.1F8E7C43461@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 10:59:33 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-02-12
    https://git.kernel.org/netdev/net-next/c/79201f358d64

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


