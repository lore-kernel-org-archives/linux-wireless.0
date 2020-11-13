Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA29FC56202
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 20:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DE542224A
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Nov 2020 20:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZU6hsAC/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgKMUKG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Nov 2020 15:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgKMUKF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Nov 2020 15:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605298205;
        bh=88GdKKeWS84xHuqOFp8BE8erGPh8bam/kjzPzZhBNEc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZU6hsAC/SWrBccHFynfp7XJCkIQB31VYErzGu8xiqnPpes92m8dSGTOhwFqMfAxhy
         cdJVn+B6GLfHeoLpMYbJuBHtpIu6lonjsWIQa6ch2HRHpT2N+7TdY5AQ1X8kDejIyO
         3aZyZOTGWJMnwvuH/v3QfLLh8X5Ro8m0N1wBdY+c=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2020-11-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160529820520.6483.15559198044930525045.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 20:10:05 +0000
References: <20201113093421.24025-1-johannes@sipsolutions.net>
In-Reply-To: <20201113093421.24025-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Nov 2020 10:34:20 +0100 you wrote:
> Hi Jakub,
> 
> We have a few fixes, most importantly probably the fix for
> the sleeping-in-atomic syzbot reported half a dozen (or so)
> times.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2020-11-13
    https://git.kernel.org/netdev/net/c/1395f8df87b0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


