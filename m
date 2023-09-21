Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F59E7D0A8
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Sep 2023 18:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjIUSPf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Sep 2023 14:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjIUSPK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2023 14:15:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3103583F43;
        Thu, 21 Sep 2023 10:37:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8419C116AE;
        Thu, 21 Sep 2023 08:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695283729;
        bh=nJaYB8uCoRYXDXO2rEMYKSZU2AEtKUxZKZjNBbP5yx0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=q7U3o4KOKAt6ddMSu4iMCNpdJ0lygN6aVaZkka9VdPOMVGPBdrl62qR1kwBKNhfDJ
         rB9wXuFzUj0pBLmQzotRCXgD5wuDo7nqMxV9t4ex7J7BLKUVp2E2AxC3S7vMsa/3fU
         +aDkez0WG6bHzw+WEl/8GLIMqY4HW4l6+81YgSDgbnuFXhHySdvf3UATYPqf4OCStT
         J/rRvQEWibsp6/+zk9tBe2cCCg0CRiAN9h2lrStdBz3H7fGjuzFMu7fVJyie3MxG4R
         tBz/5MAT6Bs6rLxi9q2+OC7oTPAh3N7+CkZs7M8fTKi9G6L+Gf3NRuvnxFlmnCsq9e
         iCZdtvr/8coFQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 wireless-next 1/9] wifi: ar5523: Remove unnecessary
 (void*)
 conversions
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230919044906.523189-1-yunchuan@nfschina.com>
References: <20230919044906.523189-1-yunchuan@nfschina.com>
To:     Wu Yunchuan <yunchuan@nfschina.com>
Cc:     syoshida@redhat.com, johannes.berg@intel.com,
        alexander@wetzel-home.de, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Wu Yunchuan <yunchuan@nfschina.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169528372582.1539628.14233908546139336293.kvalo@kernel.org>
Date:   Thu, 21 Sep 2023 08:08:47 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wu Yunchuan <yunchuan@nfschina.com> wrote:

> No need cast (void*) to (struct ar5523_cmd_hdr *).
> 
> Signed-off-by: Wu Yunchuan <yunchuan@nfschina.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

6 patches applied to ath-next branch of ath.git, thanks.

37c113e94fa0 wifi: ar5523: Remove unnecessary (void*) conversions
9705103f8e8e wifi: wcn36xx: remove unnecessary (void*) conversions
4bd0f7d0f311 wifi: ath5k: remove unnecessary (void*) conversions
779163fa1a37 wifi: ath6kl: remove unnecessary (void*) conversions
16e972d5767a wifi: ath10k: Remove unnecessary (void*) conversions
e5e8b38f0c05 wifi: ath12k: Remove unnecessary (void*) conversions

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230919044906.523189-1-yunchuan@nfschina.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

