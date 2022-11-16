Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6B1C433FE
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Nov 2022 09:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiKPJri (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Nov 2022 04:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiKPJre (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2022 04:47:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07EBC35
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2022 01:47:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CEA061B69
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2022 09:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B87C433D6;
        Wed, 16 Nov 2022 09:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668592052;
        bh=E65Jn41x6sRefnshCUitzI/+waRzn7/12aN/3XPKQaI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dsRE00gEkNgvz265IzUE9A+MUwIZ8JYAYLA6TA1mMlFE5LnqEBOjyPcdG2j9atgz7
         eQKtGGBc4MJW0mFtBkc0gUhUazb+ZtWPLF0jz/nNuMt3juBog+h+P1+18BhrakcwWk
         r6hM4UkaU3FvsSJLNYIu8RHx4WU1rOEtilqcQridjoIdjP63RriblF1swLIlJcADAr
         Y4tOdYkE4jK/J4YLwPFVPLtmgKmizciAuPOoldqW29cvTT72pXa/uZdJNprnhsgpr8
         HiBEh8wMqKtCWv5H7MUaKX8W9t2VFRleNVJTnuuSv0ptX3wnqtDFvn9ZJofEwPGE28
         nXZ49/RlZ601Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 02/10] ath11k: add WMI resource config for EMA
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221114201912.22893-3-quic_alokad@quicinc.com>
References: <20221114201912.22893-3-quic_alokad@quicinc.com>
To:     Aloka Dixit <quic_alokad@quicinc.com>
Cc:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166859204862.26116.2408671668562363202.kvalo@kernel.org>
Date:   Wed, 16 Nov 2022 09:47:31 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Aloka Dixit <quic_alokad@quicinc.com> wrote:

> Add new fields in structures target_resource_config and
> wmi_resource_config to configure maximum vdev count and profile
> periodicity when enhanced multiple BSSID advertisements (EMA) are
> enabled.
> 
> Tested-on : IPQ8074 hw2.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
> Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>
> Co-developed-by: John Crispin <john@phrozen.org>
> Signed-off-by: John Crispin <john@phrozen.org>

Nowadays we add "wifi:" to all wireless patches, so this should be:

wifi: ath11k: add WMI resource config for EMA

But I can fix that during commit, just keep in mind for future patches. Also
please CC ath11k when the patchset touches ath11k. No need to resend because of
these.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221114201912.22893-3-quic_alokad@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

