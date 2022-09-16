Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB99C54EE9
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Sep 2022 09:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiIPJUt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Sep 2022 05:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIPJUr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2022 05:20:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F1A4D24E;
        Fri, 16 Sep 2022 02:20:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A05A62967;
        Fri, 16 Sep 2022 09:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1A4C433D6;
        Fri, 16 Sep 2022 09:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663320043;
        bh=DedkR12MGDILhlqL2Fcg9L71pkbsanV0/p9k6dJkPw8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YrHnKB9aCuyOlStG87qHn2vgKmhB8f/lOLDwdOlecy9wqckxXEOYcYC8qvslx5Da0
         +mHdd1njdWesH2eDQmIFf1FbmOMdzB98kutUvtwJR2/KqaThjt4evOD0AaaSQXwqZZ
         82GtuSknC4PPmIk5rjjFh15R631ASoVUf0x1oa2UNuM8e8EzGDKq5JlX8sIJY3gA9T
         M7fFxAv05VEnhReFRqjAooWJ3HxP1cile2rSmpXDQfvPwYR1ayjvRhIWaxLaUl3UMj
         J5tdtD2E1D2wdDmb+pxbQLdYuN02hom3VKXVNEya+JKN40iNOZpQMgBMnRnKl+REkB
         oJ8vdQ7Vg3O1Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: Fix kernel-doc issues
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220909151246.22961-1-quic_jjohnson@quicinc.com>
References: <20220909151246.22961-1-quic_jjohnson@quicinc.com>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166332003954.3127.7361037879109120019.kvalo@kernel.org>
Date:   Fri, 16 Sep 2022 09:20:41 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jeff Johnson <quic_jjohnson@quicinc.com> wrote:

> Fix documentation issues reported by kernel-doc:
> - Incorrect use of /** for non-kernel-doc comments
> - Mismatch between documented and actual identifiers
> - Incorrect identifier syntax
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

3f505a30ea6b wifi: ath11k: Fix kernel-doc issues

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220909151246.22961-1-quic_jjohnson@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

