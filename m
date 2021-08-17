Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E910C4338F
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Aug 2021 22:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F13D260EE0
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Aug 2021 22:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhHQWUk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Aug 2021 18:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhHQWUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Aug 2021 18:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 36FAE60EE0;
        Tue, 17 Aug 2021 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629238806;
        bh=88PEeN3QPvy2n7i+U59YDW1+amHB33i+8WSgBy2glF8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ur7e6pkBy5DlpJXANsQp2WzwIDe3Y0KD1cAoTbnIg1iwnZaIxeCaPBycq8MP5MGLj
         Pi+oTGwQrGkxnexkhlnPrlFReizL0ZLnGHCf4wQkit/LQwd6xcwW9mQue80UVjkSZ1
         wbqNHGbujNxQHveVKV0IEddPuM10rQLh0cgc0TRr8OXZ5976bUI+2ss+xshXv2IN1l
         uwEFDGfAx60YBfyfsTzKxG0YWmwajcO0lJpDUHX9heZ1vnVrWkWrgVA194doNYok8q
         aaXwAyGgepPq1jeLLJX7gmPwwNqWUo81jGf/ll8nmxxuKg2xbiPxmmqH/mbyI3GacO
         bJ558qvJ93rPQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-08-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162923880616.4403.10581636012968627104.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 22:20:06 +0000
References: <20210817171027.EC1E6C43460@smtp.codeaurora.org>
In-Reply-To: <20210817171027.EC1E6C43460@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Aug 2021 17:10:27 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-08-17
    https://git.kernel.org/netdev/net/c/e5e487a2ec8a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


