Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A010C7EE29
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Jun 2023 09:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241975AbjFMJtC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Jun 2023 05:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241767AbjFMJsM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2023 05:48:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9901B1FF9;
        Tue, 13 Jun 2023 02:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35CD062B60;
        Tue, 13 Jun 2023 09:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF32C433EF;
        Tue, 13 Jun 2023 09:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686649646;
        bh=3C/9k3Wp2q74e5Kj4lNKZVGCxlcGfqV9JqY5As7yd24=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XHczFg4HXbJp609NdfE1ms1DT9DpefdHDAzhkAexPPtZMyJr+vkm1d7t/NFAnc8cU
         6mwp8q9o4goDQf8DQgkcLS7iOlW1Xf8kzVvn+u1+du8pj06wCTpPk3EebXxwzA7WzS
         JjKsTchxuutlmQjmke7oyJbK/d6odL1U+tcaZFCbEx0H65kPP6VQja3ORNVOmXWxt8
         rkZCBfbuLI2L0ScSPv8K/RGqjwPsuznFwFq9dT+shvGlw9DHIdtAsmZPC+hmkEYFpi
         3gXGgklHp27nGDW7ZKXADMfg8GbvLDSXV2/t/cL4cep1C8ving+gBfAIr8jBsYyOUB
         4sQ2g330/QnHQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     baomingtong001@208suo.com
Cc:     toke@toke.dk, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath: Remove unneeded variable
References: <20230613093757.5380-1-luojianhong@cdjrlc.com>
        <b41c50989125dec782e1fbd2793d0ecf@208suo.com>
Date:   Tue, 13 Jun 2023 12:47:20 +0300
In-Reply-To: <b41c50989125dec782e1fbd2793d0ecf@208suo.com> (baomingtong's
        message of "Tue, 13 Jun 2023 17:43:53 +0800")
Message-ID: <87352velsn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

baomingtong001@208suo.com writes:

> Fix the following coccicheck warning:
>
> drivers/net/wireless/ath/ath9k/gpio.c:501:5-8: Unneeded variable: "len".
>
> Signed-off-by: Mingtong Bao <baomingtong001@208suo.com>

No HTML emails, our lists drop those automatically. Please use 'git
send-email', more info in the wiki below.

This is not the first time I'm commenting about this for a patch from
208suo.com:

https://lore.kernel.org/linux-wireless/87zg57fne1.fsf@kernel.org/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
