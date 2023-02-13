Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A37C6379F
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Feb 2023 15:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjBMPRb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Feb 2023 10:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBMPR2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2023 10:17:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45011E9C9;
        Mon, 13 Feb 2023 07:17:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 523CEB8125B;
        Mon, 13 Feb 2023 15:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E016BC433D2;
        Mon, 13 Feb 2023 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676301421;
        bh=Y9+Ws1Zx+3YsV6FF91baDKd3iynS7YMTYr6uHBJ4WJ4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Q30GdVycE5zlQU4TPwnrQ8NX1b/4jsOt6wr9v3m2hV+lcgGN/zQC0Ec9nPfqmkhs2
         6/fXpHsmCta61C1cF1tdXCj2RV3/UhNkArRGTX/UXkZ/LQ828SMTl8n+r6Jc49B/UG
         Hwl1bj9bNktJzBBfkfI/g0o5K6NAI1wrSjwdbXK7KFB9w2ZXuC5lBceSMtQZu5eX5D
         05y25UDbiAblbjWUiQc9k3Ns8jQMKzNNADRHlVO5lOpv6Du2DcSdT6N1JKYP3tBrfo
         nQBk2MWaUUBEHXHURfXEqJwDrc1pj12oXPn1ektdBIwBgcdoF6VeqDMTZcopoh5bnZ
         LIFN8xVNafeDQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [2/2] wifi: iwl3945: Add missing check for
 create_singlethread_workqueue
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230208063032.42763-2-jiasheng@iscas.ac.cn>
References: <20230208063032.42763-2-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     stf_xl@wp.pl, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630141708.12830.7843226162190527472.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 15:16:58 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:

> Add the check for the return value of the create_singlethread_workqueue
> in order to avoid NULL pointer dereference.
> 
> Fixes: b481de9ca074 ("[IWLWIFI]: add iwlwifi wireless drivers")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Patch applied to wireless-next.git, thanks.

1fdeb8b9f29d wifi: iwl3945: Add missing check for create_singlethread_workqueue

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230208063032.42763-2-jiasheng@iscas.ac.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

