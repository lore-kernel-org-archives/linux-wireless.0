Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CE7C433EF
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Jul 2022 10:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbiGRKFC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Jul 2022 06:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbiGRKFB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jul 2022 06:05:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1581D630C;
        Mon, 18 Jul 2022 03:05:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B418AB81077;
        Mon, 18 Jul 2022 10:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79048C341C0;
        Mon, 18 Jul 2022 10:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658138698;
        bh=Y93ztlln3J1SEztN6LcSHkobyzwbkcUbPWSGXikLHng=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=tz6uGRJutZqaeMamE36fWBZ/jed+TD0zpqCnIfeK1RuuRFe3O4n7vHd1QF7w/6Ck4
         6sIxNfaLGp7e3VL2uKVtDGvwus0CFv0s3xUlSIT1/KQdmLtQzfKt5stZevM9fZ/MTn
         X90LQbRSl4F4GALfda6ei2tyEIVQf/+W1b6WIoV81J9/XtsZ3IPWuXmlMJVjZJT1GA
         ZrJlYADCdcmdPyxqrEF+EbcrjUvW1FHqTqY7zA5hkuSyoYQozybvQ7+glUd8coWq4F
         Uw1PMUKzP7sgGmBjNZjtFH9+IG6BwcIvCq1yEythydMjZBZFEMPfb/lT3biVw8t04Q
         pYxlSDSTg1RTA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709124036.49674-1-yuanjilin@cdjrlc.com>
References: <20220709124036.49674-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165813869435.12812.4940246033447456212.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 10:04:56 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'have'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

88e67a4f0bf8 wifi: ath: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709124036.49674-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

