Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2472EE4993
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Aug 2023 15:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjHUP5Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Aug 2023 11:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjHUP5Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2023 11:57:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA11A1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Aug 2023 08:57:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B55A06166F
        for <linux-wireless@vger.kernel.org>; Mon, 21 Aug 2023 15:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFB6C433C7;
        Mon, 21 Aug 2023 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692633434;
        bh=DNuJ56wDsHzb91kxB3KnSoyceLy9aT5R9Tks+E/ricQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pL2cSAALG/U3dVFkO3zUf4byd8R5v5SNUUOAR1wzZpJq3OUMi4HO0lrHyq1SyagqK
         GRxGEbjdSNX+hrjBIVqQOeeIf1nQDiCLUKSE1jLeqtN4pOnh8fRRhlYxdutsZcZ0nm
         yy3um3r/TXXkwPxcVHyQHRGmWdw7KatTzsQShxz7BWzilfTyqwGNhsJJloZudVErJC
         XWh4Epkt3ckjEe6IP0+CXiVi6O9HFapa+V5GYUI7ThZNOtLX4NcQt4L44s9/Wg94xV
         Is6yVIcN8g7Sdk7aNG/7GRpqdgR7MERGQX5XyPK/1uIwY1YCqTEB47ituFODDj6R7t
         8OFl37OkWQH3Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next RESEND] wifi: mwifiex: use is_zero_ether_addr()
 instead
 of ether_addr_equal()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230808081023.2303423-1-ruanjinjie@huawei.com>
References: <20230808081023.2303423-1-ruanjinjie@huawei.com>
To:     Ruan Jinjie <ruanjinjie@huawei.com>
Cc:     <briannorris@chromium.org>, <christophe.jaillet@wanadoo.fr>,
        <simon.horman@corigine.com>, <linux-wireless@vger.kernel.org>,
        <ruanjinjie@huawei.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169263343066.572263.18373464608681147225.kvalo@kernel.org>
Date:   Mon, 21 Aug 2023 15:57:12 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ruan Jinjie <ruanjinjie@huawei.com> wrote:

> Use is_zero_ether_addr() instead of ether_addr_equal()
> to check if the ethernet address is all zeros.
> 
> Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
> Acked-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-next.git, thanks.

a9be18642ad6 wifi: mwifiex: use is_zero_ether_addr() instead of ether_addr_equal()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230808081023.2303423-1-ruanjinjie@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

