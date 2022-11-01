Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FB4FA373D
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Nov 2022 09:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiKAJYb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Nov 2022 05:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKAJY3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2022 05:24:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C881209B
        for <linux-wireless@vger.kernel.org>; Tue,  1 Nov 2022 02:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C7BECE1AF6
        for <linux-wireless@vger.kernel.org>; Tue,  1 Nov 2022 09:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76481C433C1;
        Tue,  1 Nov 2022 09:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667294666;
        bh=inhLpWUHkohQWm+ncfF2UwjJ3rlcI9OYPgpuEqTrHxs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nm+nh9uw/B2SItGFOZ3jXxZcuyfdKlYO/WKGw1PNKEEAbc4pchoqjJMYGobdE4ZSl
         5JXSP/vDu1n6rdWjzutR3NkCdYwEsglBZwZdcHlJtx7LGk6B2DcQ/lAhCDnXRrPstn
         RI3cFzaDuPM9xV0OWi7Afma1sB3hvz+09YBLP2tg03msAnoDup+RvFyr6QxD37KvG0
         9XbHi7+4cK901Dhqu9KNxEv6rIrLnvWw4/gv482IT2L8tUOzH8Zz2oMw9JGhI/f2/X
         J0QpVOCJ0Y4nqJoYKsO379bpSzcNuIGJRQXDzHx4wZPrzxA6rHYdZN4mBs/lCeXrmI
         r30MTDNzOsVug==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw89: fw: adapt to new firmware format of dynamic
 header
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221020052549.33783-1-pkshih@realtek.com>
References: <20221020052549.33783-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166729466318.21401.9469768169715352219.kvalo@kernel.org>
Date:   Tue,  1 Nov 2022 09:24:25 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> Since firmware size is limited, we create variant firmwares for variant
> application areas. To help driver to know firmware's capabilities, firmware
> dynamic header is introduced to have more information, such as firmware
> features and firmware compile flags.
> 
> Since this driver rtw89 only uses single one specific firmware at runtime,
> this patch is just to ignore this dynamic header, not actually use the
> content.
> 
> This patch can be backward compatible, and no this kind of firmware is
> added to linux-firmware yet, so I can prepare this in advance.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

4feda7f317cb wifi: rtw89: fw: adapt to new firmware format of dynamic header

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221020052549.33783-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

