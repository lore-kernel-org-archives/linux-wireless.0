Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130A3C433FE
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Sep 2021 12:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E38886108E
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Sep 2021 12:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhI0Mvp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 27 Sep 2021 08:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234331AbhI0Mvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Sep 2021 08:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6460860FF2;
        Mon, 27 Sep 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632747007;
        bh=uv2JgPIh+W7K5qOmLaJg/qvjin3SfCLs/xhwb0uia7w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VBuGp3SYjVxbd/X5aQ70HTG1HgoqrH54h/qLarxx+xq/NwaBBWkOapiGEBGHI+cyk
         WJTGg9359U8qXnNy+ydBsFPj4TPA1QwcrDLoHSFnRYs5WkKpYVzL5UHtQO43qrbtWR
         DJ2rOPXy66zNpCmMBmKcQOuYxq3UPNgMOiW+rNw4LZ5Q3HDZaRtPSxaL/a/Z1fyFGr
         TMXoI9vwE4pON2Hr9PZ1H4zi1UcWuoyj2AaCvCRZz3KlGPrqwmoP3LAZtDyTrSiWea
         P2aqBhn08TI4JId5wI2sBP5nbhrSjbDJqggA7P/7OTGPb0XUlLMBkC8BvdwIbSvyJ3
         TNZIt+5PpMAHw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-09-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274700736.11108.10539648638608356654.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 12:50:07 +0000
References: <20210927102057.45765-1-johannes@sipsolutions.net>
In-Reply-To: <20210927102057.45765-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Mon, 27 Sep 2021 12:20:56 +0200 you wrote:
> Hi,
> 
> So somehow this time around we ended up with a larger than
> usual set of fixes - see below.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-09-27
    https://git.kernel.org/netdev/net/c/ca48aa4ab8bf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


