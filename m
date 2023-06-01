Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B947C77B7A
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Jun 2023 13:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbjFANP0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Jun 2023 09:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbjFANPY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2023 09:15:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5781A5
        for <linux-wireless@vger.kernel.org>; Thu,  1 Jun 2023 06:15:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7EF660DBE
        for <linux-wireless@vger.kernel.org>; Thu,  1 Jun 2023 13:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446DEC433D2;
        Thu,  1 Jun 2023 13:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685625301;
        bh=qWHMtfyPY/7yfxpLuiG8+18ESgjkmy3MguGocPq49wY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pIqg5A784B+qGdUi4B2rMDs8LvnHA9xaATKEb9DimR+b7C/ZZjwapOsinf12ZgH0/
         etmJz+71tXMiqxwO/KUtMBPErCMq8PqGfuWPuP9CULd6IMpEF9xBHvFqBHPbRv/Cdz
         QsFvK2ryz2/BFcx2cyz6XzT03L9qvPR2zkz61xob/dn6RQGsncUDBRxtm3XlPhFZqr
         PTZGGDoQqabbkrqVc5YCRMzJiDzekSXmNkzwGV+8brLclUZWN8YxoGt+dZngpL72Pk
         RRGGL+zuUds24wjV0qAd+H6W0gWvTwbuTcgogqtAXz2xTymmxKrfGemloDhXzTN67D
         PmY+l5kZuuloQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless-next 1/2] wifi: rtlwifi: use helper function
 rtl_get_hdr()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230527114954.3281-1-claudiajkang@gmail.com>
References: <20230527114954.3281-1-claudiajkang@gmail.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        pkshih@realtek.com, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        Juhee Kang <claudiajkang@gmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168562529725.11223.6683871783268624490.kvalo@kernel.org>
Date:   Thu,  1 Jun 2023 13:14:59 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Juhee Kang <claudiajkang@gmail.com> wrote:

> Although rtl_get_hdr was added in commit 3dad618b7b92 ("rtlwifi: Change
> wifi.h for rtl8192se and rtl8192de"), it is currently not being utilized
> in some areas. This commit replaces the open code with the rtl_get_hdr()
> function.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

2 patches applied to wireless-next.git, thanks.

3e450386e99e wifi: rtlwifi: use helper function rtl_get_hdr()
8012ec4a0e64 wifi: brcmutil: use helper function pktq_empty() instead of open code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230527114954.3281-1-claudiajkang@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

