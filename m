Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0404C38145
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Sep 2022 12:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbiIBMgh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Sep 2022 08:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236265AbiIBMfx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2022 08:35:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58938D6335
        for <linux-wireless@vger.kernel.org>; Fri,  2 Sep 2022 05:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CA69B82AA6
        for <linux-wireless@vger.kernel.org>; Fri,  2 Sep 2022 12:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BD7C433D6;
        Fri,  2 Sep 2022 12:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662121720;
        bh=e+U24dMk/hVmt2QABbAWhHrVrdQ9lGxzE6AGBgzMrRI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=E3W+l5+/gpwtSpcsYI0VJkC/skmdvbyU+PoHcuKWcwXepIhQy1SFg2GYE2akBR8U0
         lhRhUcQfIpbk8YINp/tXwNKd3YsA7wVQq/7yogJahYJ/OuJ0MabBhkPB0TZMM3wFVM
         FohhOINOoZ/yKFXPfQ4WxAOfYMAFB1DtrTzUcJrf0foAjHKL2lkWt7B8pqIBQ0od1M
         21yJnPVK1Pi0sls5hZplEjj06mIj39qfigt1LXPHM781P/hl8WNuQupN4S7cIrcjdO
         rk9D580BNdSaIgzQoBWvpPtq4MEC2uW2cSadl/wNpIuTl2GxMzbZCtftnOPbVsavel
         GSgjUotDLF9IQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath11k: Add support to connect to non-transmit MBSSID
 profiles
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220901080616.29414-1-quic_mpubbise@quicinc.com>
References: <20220901080616.29414-1-quic_mpubbise@quicinc.com>
To:     Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166212171811.9935.14952396417048197935.kvalo@kernel.org>
Date:   Fri,  2 Sep 2022 12:28:39 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Manikanta Pubbisetty <quic_mpubbise@quicinc.com> wrote:

> Add support to connect to a non-transmit MBSSID AP profile.
> 
> Non-transmit MBSSID profile parameters are passed to the firmware
> via WMI VDEV UP command and this helps firmware to track MBSSID
> profile within the multi-BSS beacon and report beacon loss if
> any.
> 
> WCN6750, QCA6390 & WCN6855 firmwares have the support and hence
> enable the support on these hardwares.
> 
> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1
> 
> Signed-off-by: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

7d992bd4615c wifi: ath11k: Add support to connect to non-transmit MBSSID profiles

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220901080616.29414-1-quic_mpubbise@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

