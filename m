Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79184ECAAD3
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Sep 2022 08:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiIGIUW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Sep 2022 04:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiIGIUU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2022 04:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CE627DDE
        for <linux-wireless@vger.kernel.org>; Wed,  7 Sep 2022 01:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0E61617BB
        for <linux-wireless@vger.kernel.org>; Wed,  7 Sep 2022 08:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D49CC433D6;
        Wed,  7 Sep 2022 08:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662538818;
        bh=vC1xo+f/KdGX8B0lKVlxVLXN+g1w016Xr/3R/zixVPo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gJvE3dXJYJOtsg/Mtkg1BHuJGOO3ZtWuUe2h3bqZu1VcJfIgQsZxhwM8YVzxRrIdl
         plgWcPZxKCcx4/0hZAdyjbscZLQLM99BiIW6sq7X3zrXhVZ6r+ncMSPbIe2doBEXGg
         YaU46pI00XlWcVI+pPcP2unVuE3XZD7KUtx2A3Qv2kANQkm8ANSwIRA9U/0NP0+jJ6
         49G0en/VqvmmhSROw2NjNU9ULYcXXCz/1ANZ8ZuUpmrYedFU4RBT/zNR0sq9jCc9rj
         1n2A7Jr65CJFLrZlxREA0qXG40CeETaM1cfTFPN503X0tsHmjoDOEKNgOIgJTcXlP4
         K0I2nWrMjIWnQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath11k: Enable remain-on-channel support on WCN6750
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220901080656.3450-1-quic_mpubbise@quicinc.com>
References: <20220901080656.3450-1-quic_mpubbise@quicinc.com>
To:     Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253881172.23728.9477056475033732029.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 08:20:17 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Manikanta Pubbisetty <quic_mpubbise@quicinc.com> wrote:

> Enable remain on channel support on WCN6750 as it is needed for
> GAS, Passpoint.
> 
> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1
> 
> Signed-off-by: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

36893e45b192 ath11k: Enable remain-on-channel support on WCN6750

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220901080656.3450-1-quic_mpubbise@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

