Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A76CDB483
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Oct 2023 08:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344639AbjJRI2u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Oct 2023 04:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbjJRI2s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2023 04:28:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF84BA;
        Wed, 18 Oct 2023 01:28:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C7AC433C8;
        Wed, 18 Oct 2023 08:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697617726;
        bh=v5UHIdxwmYituZm5VELfBrx/aD0CnXn++nmORWapCTo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WIntCHgUvaC/Y48RIKYl/z3/eCT2JVB6mDyv5P+Kt/kVRc+8uulOasO35hnMI1/1D
         SCF6Q21ZiI8BfwXxEdmnrbqn8rl9hCBcqqbQJveyvTRx0BT5zFHVIgJBtxmNdMrzvw
         TWUcIZ3pTLKGD561E1MXWPfzbxuFkQ9bYnEB4ZLqYwmi/zWIukJDrBYQiVDxrMiOu9
         nZ4sLSfZ7aMYFSKiK9gUiSZtn46GmejsNgjJ+d9rrpWNmlC8Z8VB5oD5jMTO5mPyHs
         ujpEip5ONCLepD1AtYv5FciZRsbjjkmMiSCNSayy08jaVVmPu3a3snTBsxDhaRkEuu
         qhsy8Eq6t9PEQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] net: wireless: ath11k: Use
 device_get_match_data()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20231009172923.2457844-11-robh@kernel.org>
References: <20231009172923.2457844-11-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169761772362.48072.11114311849759116023.kvalo@kernel.org>
Date:   Wed, 18 Oct 2023 08:28:45 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rob Herring <robh@kernel.org> wrote:

> Use preferred device_get_match_data() instead of of_match_device() to
> get the driver match data. With this, adjust the includes to explicitly
> include the correct headers.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

9d2c23d21aa4 wifi: ath11k: Use device_get_match_data()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20231009172923.2457844-11-robh@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

