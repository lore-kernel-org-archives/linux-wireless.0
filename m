Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92ABAC43217
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Dec 2022 11:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiLALGL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Dec 2022 06:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiLALE7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2022 06:04:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA9AA9CCE
        for <linux-wireless@vger.kernel.org>; Thu,  1 Dec 2022 03:04:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18E1E61F91
        for <linux-wireless@vger.kernel.org>; Thu,  1 Dec 2022 11:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1816C433D6;
        Thu,  1 Dec 2022 11:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669892686;
        bh=P+T3+BqyeenjFmfnlO5geK5f8KezPDMDJutJVVfywXE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PI6+6s7OjJ4li3JcMgxgXn6X9gPSNtZwNvBOQmkhgorXQKfwzQJDJ3aHiJ3npGVUb
         BtlL5lMmoojfG++dMjnXCn6t+cwJsh73+NuR25GjNG5HKCfT0EwRe/kCERvNgZ0ftF
         Rr2wSKE+3UmOAm4EUbaciMYgDE10gpGfEocUlN/iRXhg79lHT2UMrt9CT5LvZrqwFA
         EcfakZXCrGmlPEK/30n171S9Z15GVF0Lva3lKcn8E3YQi7VEylTtQWHva5aYJ7ILQT
         GWNNCJdre1iHa0/ejsVP5oOOcirNvG5bZ2BdX1oQ1obUCbAS6GG8goraWLJuHREA08
         3kT+bKG1X9rDA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/6] wifi: rtw89: rfk: rename rtw89_mcc_info to
 rtw89_rfk_mcc_info
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221129083130.45708-2-pkshih@realtek.com>
References: <20221129083130.45708-2-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <kevin_yang@realtek.com>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166989268389.31196.6019933506455532187.kvalo@kernel.org>
Date:   Thu,  1 Dec 2022 11:04:45 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Zong-Zhe Yang <kevin_yang@realtek.com>
> 
> The `rtw89_mcc_info mcc` is only for RFK MCC stuffs instead of common
> MCC management info. Replace it with `rtw89_rfk_mcc_info rfk_mcc` to
> avoid confusion and reserve `struct rtw89_mcc_info mcc` for MCC management
> code.
> 
> (No logic changes.)
> 
> Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

6 patches applied to wireless-next.git, thanks.

38f25dec521e wifi: rtw89: rfk: rename rtw89_mcc_info to rtw89_rfk_mcc_info
860e8263ae92 wifi: rtw89: check if atomic before queuing c2h
22b10cdb7392 wifi: rtw89: introduce helpers to wait/complete on condition
ef9dff4cb491 wifi: rtw89: mac: process MCC related C2H
c008c4b011ba wifi: rtw89: fw: implement MCC related H2C
75ee07b03fc6 wifi: rtw89: link rtw89_vif and chanctx stuffs

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221129083130.45708-2-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

