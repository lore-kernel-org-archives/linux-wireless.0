Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE55C48BE8
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jun 2021 19:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E365A61279
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jun 2021 19:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhFRTcP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jun 2021 15:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233206AbhFRTcO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jun 2021 15:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 15630613BA;
        Fri, 18 Jun 2021 19:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044604;
        bh=ztcLJMnHB+1i+Ka4PpU3g8STMlwlFVA2GWT3Bt6s7Zw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JlFtHPwu4kJUGsP6RCFOR8jfdW5XAJgYufJoLq4Nua0CDU2GWuKTCPjr2Weqf1uJ4
         dvHB0d5o1k8v1tg7Xcqxi207cYi0RomZaZqN4s0IGhRa7x9PKQqoMT3qUtIgrTHmwS
         4kTrkoskphJBkGF2x5O1K0k5Blcf9QY9Wvc3voTDXAFuF3X2jxHdgApoLBmYHg4E4M
         MHyJUz1nFErKkq9DNVvxGMhlPsPFJFCPg2kgQTigsfEaB1hPf5xVr29Xoazsc1L5VJ
         Gw0EJzTIdOUE5ziCxn/PX3gV61iHBLJWDds7lTuPC5q3ox8vYaM/I622pWhM5/U20c
         vkD/xcg7Yz3ZA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-06-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404460404.16989.1294077837661779323.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:30:04 +0000
References: <20210618114211.49437-1-johannes@sipsolutions.net>
In-Reply-To: <20210618114211.49437-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 13:42:10 +0200 you wrote:
> Hi,
> 
> We've got a few more stragglers for hopefully 5.13, see
> the tag message below for more details.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-06-18
    https://git.kernel.org/netdev/net/c/0d1dc9e1f4c0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


