Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B77C433EF
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Apr 2022 11:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345633AbiDALv4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Apr 2022 07:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiDALvx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Apr 2022 07:51:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED651D41AB;
        Fri,  1 Apr 2022 04:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 726DCB8245D;
        Fri,  1 Apr 2022 11:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAC4C340F2;
        Fri,  1 Apr 2022 11:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648813801;
        bh=C/02jTqmwSqYIvFHv2RbQpqDzMIMbFGpjQRlMdl2u54=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XXJS0n7HzVeqDVF5ECjjBjNYktLSK1xu6m6Zjsz33TuFNkNHG4YOj3ATPfJgQ80pN
         n1soOay+IknNxdXT6E96AFTAOPh/Ed+MJzITeA5AlxjCK32kU4JROU5jMeO6vyfPjv
         swKahUPRA65Gu90P8MlawrSrcsmfSvKS0oReFrAVQn7rDBTmyepSdz2S0Ok4LxXu3X
         Y8yWu7v3OL4GpGqi5w3jIyeMKW0Yp37xa6Y1rlJEpTNwtiDzneed3wT1yLzFUXwngb
         091aacvx2KReFKtH+qK0exu4lj6zDfJt/vi2BGuVFrwukGOAnX5lOXnuLf5Anjyrx2
         Q/OFLnNGrPhJQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] wcn36xx: Improve readability of wcn36xx_caps_name
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220328212912.283393-1-benni@stuerz.xyz>
References: <20220328212912.283393-1-benni@stuerz.xyz>
To:     =?utf-8?q?Benjamin_St=C3=BCrz?= <benni@stuerz.xyz>
Cc:     loic.poulain@linaro.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?q?Benjamin_St?= =?utf-8?q?=C3=BCrz?= <benni@stuerz.xyz>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164881379683.6665.4776663816367931792.kvalo@kernel.org>
Date:   Fri,  1 Apr 2022 11:49:58 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Benjamin Stürz <benni@stuerz.xyz> wrote:

> Use macros to force strict ordering of the elements.
> 
> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

9149a94adad2 wcn36xx: Improve readability of wcn36xx_caps_name

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220328212912.283393-1-benni@stuerz.xyz/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

