Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D212C4332F
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Oct 2022 05:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiJSF67 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Oct 2022 01:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJSF66 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2022 01:58:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453B653D10
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2022 22:58:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17FF161574
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2022 05:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E732BC433C1;
        Wed, 19 Oct 2022 05:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666159134;
        bh=FYmcKcVy3ZkdN2D2Sc/RgMxskjuM1wCW7k/m0IMlNwE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EQCgf9/yFlFq6ZE5wThFPPVXOM4zjdSq1LVXHaQ6IH92eQhvJND0ubqk43FltPnJH
         WWgxNVXWRiIKOYzEjZdFiNZgUMX3twnkpj4FfOxmpGEloxWgdV1G7WK0/inmjETj7L
         pG0mHEgJWXLFf14guoRGKCXv0dFuENHS1MXZRI67oaHpOSFKr0DxLhp/kx1K8wsYwT
         0YxWpFvQW2M/nIMxfQqBFsjzgvmRQro2v4rGnrSfX+Ah6CdwQKWTCabSA382FCJ4+w
         wWNefHEeF5CxEVNmcFkSZ7S3LURK2TK9ZUYdqsvdoKZVgac0KcL8TApeSiPTwoD3Zz
         JGDh/4mqymtiQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] wifi: rtw89: 8852b: rfk: add DPK
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221014060237.29050-2-pkshih@realtek.com>
References: <20221014060237.29050-2-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166615913174.17379.9844588861138524931.kvalo@kernel.org>
Date:   Wed, 19 Oct 2022 05:58:53 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> DPK is short for digital pre-distortion calibration. It can adjusts digital
> waveform according to PA linear characteristics dynamically to enhance
> TX EVM.
> 
> Do this calibration when we are going to run on AP channel. To prevent
> power offset out of boundary, it monitors thermal and set proper boundary
> to register.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

4 patches applied to wireless-next.git, thanks.

5b8471ace5b1 wifi: rtw89: 8852b: rfk: add DPK
ef8acbcac681 wifi: rtw89: 8852b: add chip_ops related to RF calibration
3b66519b023b wifi: rtw89: phy: add dummy C2H handler to avoid warning message
b5db4ef38e21 wifi: rtw89: 8852b: add 8852be to Makefile and Kconfig

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221014060237.29050-2-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

