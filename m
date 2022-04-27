Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2443C433EF
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Apr 2022 07:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358835AbiD0Hcp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Apr 2022 03:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358834AbiD0Hcn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Apr 2022 03:32:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8365D7DE11;
        Wed, 27 Apr 2022 00:29:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 156FDB82500;
        Wed, 27 Apr 2022 07:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B615AC385A7;
        Wed, 27 Apr 2022 07:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651044570;
        bh=Ta0SO68NoR0414iO47Ggg0jzCo4X9cCEsTKfFHr8qzo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=G9XgMS2w5Fcg5HlxnIzM64lhCnFf5r0KwsJVsoapMsnsU4d/V2lgCREUTxbdFy5eI
         hp+q8k7w/JIJ/osc6YQRJ2M298egSiN74N5n+l0sErtaFehM6RWFW+ovKDCR52NTLG
         Hg5u3ER0TRL4v00PLgshjBOd7g8Ie1W5PFn/JOd0QF98LTEeMO+aeloG8mOEIcjdDU
         WUD2PiRheQhU5VnGjSl/WqKbeR3tCdQDc6BOGQ1mVbAPVGh5yg8i0MeUMa85mG2soc
         z4jP5wyzls5Yk/cNOE+ugCSiJM8gRm8N2Ewt2esVZ5lj66yM7kdabZUr7gbR0vugE4
         rPg1AJXuSNC1g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wil6210: simplify if-if to if-else
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220424094552.105466-1-wanjiabing@vivo.com>
References: <20220424094552.105466-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net,
        Wan Jiabing <wanjiabing@vivo.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165104456697.30072.15518175455967262510.kvalo@kernel.org>
Date:   Wed, 27 Apr 2022 07:29:28 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wan Jiabing <wanjiabing@vivo.com> wrote:

> Use if and else instead of if(A) and if (!A).
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

a5f3aed5889e wil6210: simplify if-if to if-else

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220424094552.105466-1-wanjiabing@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

