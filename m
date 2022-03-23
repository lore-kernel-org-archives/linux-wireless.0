Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6521C433F5
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Mar 2022 08:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242938AbiCWI5B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Mar 2022 04:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240485AbiCWI5A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Mar 2022 04:57:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A185EDFD
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2022 01:55:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B8D361777
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2022 08:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF16DC340E8;
        Wed, 23 Mar 2022 08:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648025728;
        bh=nZ1JgEfV1rqC/sZez7dqsVtQDIRMWneohHn3iaq+qVk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LFYmJIK87r8SLQNbik9a4rWTCLSGgz2NfQEbyr72LLVkR+bL120BnlMac0PqfVcnW
         m5wDI+ZizLa1PM8ppgcufujb0As9QrZjF8qjhV1Ynj1l+J7x2HOj2pLju4gua9fTw/
         5EXvmtUFe5x4jkNewc4CRUP8SnAr7uDm7B1Ra196PQ+EsF2lRMO/50gybjzLuvy8Hd
         EexgQEBHe+x3jlTqCLAgqgqLsw1s/0zuvj4UAeq8oGu0cunnpwJOoHY//nDrcVj4ym
         XQ/NXdSYZqeIxzIEs4MXQgPu0mkGtF46jdCPeU6muYTM3fv27FfKCxQWWRJ/pvJiFl
         VLHLkzV34pRdQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] ath11k: remove unused ATH11K_BD_IE_BOARD_EXT
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220319023543.14288-2-quic_wgong@quicinc.com>
References: <20220319023543.14288-2-quic_wgong@quicinc.com>
To:     Wen Gong <quic_wgong@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <quic_wgong@quicinc.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164802572546.545.8976809392299986572.kvalo@kernel.org>
Date:   Wed, 23 Mar 2022 08:55:27 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <quic_wgong@quicinc.com> wrote:

> Currently ATH11K_BD_IE_BOARD_EXT is not used, so remove it.
> 
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3
> 
> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

2 patches applied to ath-next branch of ath.git, thanks.

7fb376ad7d3f ath11k: remove unused ATH11K_BD_IE_BOARD_EXT
0c104b6163e3 ath11k: disable regdb support for QCA6390

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220319023543.14288-2-quic_wgong@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

