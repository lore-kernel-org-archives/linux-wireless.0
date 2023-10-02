Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF46E784AB
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Oct 2023 16:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbjJBQzD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Oct 2023 12:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238493AbjJBQzC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2023 12:55:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53836A9
        for <linux-wireless@vger.kernel.org>; Mon,  2 Oct 2023 09:55:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2ECC433C7;
        Mon,  2 Oct 2023 16:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696265700;
        bh=l6R77HZ01blh2QJJ24Cf8mBZfE1MZp3Lc/qYTwT536s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jRvCBWhEH/v0VmYwUbKMeNiLN2Tq7o6bVijkTG4OFg7UTj42F3CWe4mNSOwD5V8Zp
         9e4gSch7PWP0Jy6BaCHEpgECLQQIcj8gRhi6s2G+Ew5HFpIipcxLPTceb7S09VXWQN
         VsgXeUAu2YCvIvjbjw95gzRBSgEo+5mb8lKBmxnPtAMsAgSDiH7eNlqAwxXTbgMxJC
         OkLj/26JkK4xh7cwmYrb1satETBvSr/jaFUnmpN2Lo2F1uX8eWdgjylLkmMblg9kOn
         mlgd0wng8BTrzU43p4CrruKIIIDYpN9VWe+xLRHr6cV3MpAmhJLnMqJ8nMKeXMF98m
         CZQnB0kmpnuDg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] [v2] wifi: ath10k: consistently use kstrtoX_from_user()
 functions
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230920154018.48314-1-dmantipov@yandex.ru>
References: <20230920154018.48314-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169626569660.3936351.15391287849518283977.kvalo@kernel.org>
Date:   Mon,  2 Oct 2023 16:54:58 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Use 'kstrtoul_from_user()', 'kstrtobool_from_user()' and
> 'kstrtoint_from_user()' where appropriate and thus avoid
> some code duplication.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

3fcb81420aca wifi: ath10k: consistently use kstrtoX_from_user() functions

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230920154018.48314-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

