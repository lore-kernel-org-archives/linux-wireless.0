Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EC1C77B6E
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Apr 2023 09:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjDLJ6L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Apr 2023 05:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLJ6K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2023 05:58:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0E11FE0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2023 02:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC16962D39
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2023 09:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62668C4339B;
        Wed, 12 Apr 2023 09:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681293488;
        bh=GVh+aeYBaYA1KFeRtn+mqjStl4mXaYNEb0W2W45Xcvo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eUG7oEY5x3ojHRZAxc1IWNdIgTbdBgdyPtb4607xe8NG5uPr3qVp3NFxDH5xjgZ9G
         0dlGZBfSPJJo/DL4e8N13YrUJJ4rqW8Dc0pjzjV0Pr9/LBCsuBaU5doGNTuuQAVQUd
         K6OZGgEk5l1JMzBAyL+uN7ss+brhw1v4gWkaCzpWNu7/WZ1M4CNAl6+PykXJz713AV
         fXMG0bFJuSYIy+Tqdj4qz+S7kdPHsafa7RiTOeNS6R2YF3GPT3XMFO4YJP0KLcH+WZ
         5mf5wYsTg9OxVdBypDdCJk6OZ0Glm1J1i7pIIrQkgu736GEAq3p/elRqgLsmkZN0hC
         cklPl3Hcv5i4g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: Configure the FTM responder role using
 firmware
 capability flag
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230317072034.8217-1-quic_gjothira@quicinc.com>
References: <20230317072034.8217-1-quic_gjothira@quicinc.com>
To:     Ganesh Babu Jothiram <quic_gjothira@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Ganesh Babu Jothiram <quic_gjothira@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168129348537.14673.10410864302995200064.kvalo@kernel.org>
Date:   Wed, 12 Apr 2023 09:58:07 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ganesh Babu Jothiram <quic_gjothira@quicinc.com> wrote:

> Fine Time Measurement(FTM) is offloaded feature to firmware.
> Hence, the configuration of FTM responder role is done using
> firmware capability flag instead of hw param.
> 
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Ganesh Babu Jothiram <quic_gjothira@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

813968c24126 wifi: ath11k: Configure the FTM responder role using firmware capability flag

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230317072034.8217-1-quic_gjothira@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

