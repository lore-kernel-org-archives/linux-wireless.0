Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE28DC433B4
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Apr 2021 21:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E586128A
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Apr 2021 21:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244078AbhDWVK4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Apr 2021 17:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244030AbhDWVKx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Apr 2021 17:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 37BC761464;
        Fri, 23 Apr 2021 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619212216;
        bh=cvVrYMjQ+u2hLU8HErCSOSZDV/fIdKBk9pf4BZIwwPc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PPrcTdE7O7zDMHXHVBKcR+j7N/oYuDwq76YpCQLRejW7zmu3cK/k41a+AzyP/gAb+
         YjuxFyShXk8/3QbpHW63IgFbWFbRVXwgdcbXGm1ZrjFUFXkPy5H4hpnB7QNremKXT0
         ZQ5h4x5ePZrl+1vPsBZK6xe10LQbDDaT/+o8WMZ791Y2ZI5upMRxDOBzNP2R25nICS
         bN+0caScIGhZU6l+6bnEd8bDLa+LFPilCaFcjmJ4QQ50jASOFqb1p/n7zpRZZvLfTl
         nQ58xNVP7291S6wat2FcFNqUQNQKMh284pGv2MR8Mqb1s+J7VApIWQ+n2edezlMrw2
         hm8vuUH/f/6kA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-04-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921221619.24005.15107300126619560416.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:10:16 +0000
References: <20210423120248.248EBC4338A@smtp.codeaurora.org>
In-Reply-To: <20210423120248.248EBC4338A@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 12:02:48 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-04-23
    https://git.kernel.org/netdev/net-next/c/e40fa65c79b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


