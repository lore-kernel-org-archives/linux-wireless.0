Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4ADBE732DB
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Sep 2023 15:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjI1PHM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Sep 2023 11:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbjI1PHE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Sep 2023 11:07:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3711B1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Sep 2023 08:06:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2742CC433C8;
        Thu, 28 Sep 2023 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695913618;
        bh=ClghSr2Zt4PMbSNdtJuup5mNFI8jI1jAJR5AfuRQ/1E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dFXVEk4LrsrYvJyNN4yQpBrkvFWt4iG57Jlbf49A/5jT45OfbjwYCPg0I8skOer7/
         FPtTvmT8ZjSLCEXMPg29DciBN5hjU/AFcTYLPpS8/6Mv2Dne6EUP5by9jk4r0q82mB
         FGMdW/UT9ykQEpdJF7jWtz5xvBBKYe7j8QsFgaZXzZNPCG39vv9RRUd+8utahJUc3s
         A9VyjWALg9JTeBIgy3oZRTOiFkZMV2/0gRaDlpR1kCNRyESHJyZ+86aCA6vl4xR5BR
         uaSZQcPHU4myIMS0RwIOr+EuviGMCydWLsGss5J4j4REMaHORafAY6TQSS//WtJ5pJ
         GwvYpRXI0+aYg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath12k: change to treat alpha code na as world wide
 regdomain
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230906090355.19181-1-quic_wgong@quicinc.com>
References: <20230906090355.19181-1-quic_wgong@quicinc.com>
To:     Wen Gong <quic_wgong@quicinc.com>
Cc:     <ath12k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <quic_wgong@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169591361532.3019228.18442918001635347196.kvalo@kernel.org>
Date:   Thu, 28 Sep 2023 15:06:56 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <quic_wgong@quicinc.com> wrote:

> Some firmware versions for WCN7850 report the default regdomain with
> alpha code "na" by default when load as a world wide regdomain,
> ath12k should treat it as a world wide alpha code.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4
> 
> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
> Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

c86ba8ee7e32 wifi: ath12k: change to treat alpha code na as world wide regdomain

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230906090355.19181-1-quic_wgong@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

