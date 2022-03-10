Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45884C4332F
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Mar 2022 16:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242528AbiCJQUn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Mar 2022 11:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242290AbiCJQUW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Mar 2022 11:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C861198EE5;
        Thu, 10 Mar 2022 08:18:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94AB161B6D;
        Thu, 10 Mar 2022 16:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A778C340E8;
        Thu, 10 Mar 2022 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646929126;
        bh=bjSaDa0E76WAPivOfFMo4r17rOKeNRNOgTwGr4b32Kc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=rDoWNfdCr/00ZOOhpkl2IXkOd6R2nCJ0PN6Ba+w48ARHIkyX0EdnoGCofqIYfC2Am
         UIPPwqG/1dyeouRMPoo45srelkTZHPEVP9LWCISxPP8K/kmHdCCNlvxbCTN5LGHAqW
         0QKE0TtTzyKtDkiY3hMN7WZu7lTwmjA79SlwLhwHvTOU5sSEo0GVOBP2r4zKLUEclw
         E30en0mgo6R1XJxTBngpwBFn3K6xaDOSuv+V+/o0z7JODRGJCbJnTjPm/kz3COF/i5
         2Zc1+8WzvMq36WuhA7NqqsLcW7WLUYR+BRPeIKd3JPxJjOpOxBiLoPEVm9AFMhIm/Q
         t6w0AzGhimkng==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8192ce: remove duplicated function
 '_rtl92ce_phy_set_rf_sleep'
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220306090846.28523-1-jiconglu58@gmail.com>
References: <20220306090846.28523-1-jiconglu58@gmail.com>
To:     Lu Jicong <jiconglu58@gmail.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Jicong <jiconglu58@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164692912207.6056.2372494264158291029.kvalo@kernel.org>
Date:   Thu, 10 Mar 2022 16:18:44 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lu Jicong <jiconglu58@gmail.com> wrote:

> This function exists in phy_common.c as '_rtl92c_phy_set_rf_sleep'.
> Switch to the one in common file.
> 
> Signed-off-by: Lu Jicong <jiconglu58@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

cb459950edcf rtlwifi: rtl8192ce: remove duplicated function '_rtl92ce_phy_set_rf_sleep'

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220306090846.28523-1-jiconglu58@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

