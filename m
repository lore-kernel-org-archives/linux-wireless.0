Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B314C4332F
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Dec 2022 18:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiLUSvt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Dec 2022 13:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbiLUSvV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Dec 2022 13:51:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3B8EE1C
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2022 10:51:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC627B81C02
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2022 18:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95D8C433EF;
        Wed, 21 Dec 2022 18:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671648676;
        bh=Pxe64/i/mmVuOMifHExIqJEYaAzMOHMdAsLzW7ynJoE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=l1026CQRv0GjqSDQ3rC5rZD3+sp/GRfcge0ooL9fQpPlLUzhlSreV19b062m0E9Cr
         cnT/4dm4PMZ5alctVElJKj/1EbrQk9D2rATJMEKVPi8k9I5D3SiQ9XWIEbZKwHKoK7
         7uJzYn1/p9L6dzgqXb+DKmDZIp2iT915E7Y8TFzGp920PLF2KN8vmEMVrNz7rkNnSy
         EoJ1ANDlrVwerFrZMJPpnmhCWXKttIi1TGOX00ROyjBhZ5bc7wlxunuw6xYQInUEeX
         YbKFiuy5GTYTiYNZJGHq3M8GWpDnwgYIo5NUt2JLgXzNxoU7Vh/vov94tGwZRZNGNj
         444sy+MSRrU2g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: rtw89: 8852c: rfk: refine AGC tuning flow of DPK
 for
 irregular PA
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221216052939.9991-1-pkshih@realtek.com>
References: <20221216052939.9991-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <gary.chang@realtek.com>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167164867402.5196.14538217171216063467.kvalo@kernel.org>
Date:   Wed, 21 Dec 2022 18:51:15 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Chih-Kang Chang <gary.chang@realtek.com>
> 
> Some hardware modules don't have good RF characteristic as regular.
> It could have RF PA characteristic that current code doesn't handle
> properly, and it runs into wrong DPK flow that doesn't complete DPK
> resulting in bad EVM.
> 
> Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

ba1a6905c718 wifi: rtw89: 8852c: rfk: refine AGC tuning flow of DPK for irregular PA

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221216052939.9991-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

