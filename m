Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F90C433F5
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Feb 2022 09:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbiBYJk6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Feb 2022 04:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239199AbiBYJkw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Feb 2022 04:40:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D08239D42
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2022 01:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8578560AD6
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2022 09:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60659C340F1;
        Fri, 25 Feb 2022 09:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645782019;
        bh=afJYFTbZfw2Ka9eu8A+Lf9pQugaJqVln+xIBleJagVU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FZjkoJ6KTAmyGVEcm1i1RzzpScJowae1FDzusYu4termiU3Y9Nr8YhSwXBo7Lalxx
         uO+L5dU5k50uOb7xiOS/nKZs24MbyPN2vi4+Tp/NBJwSu2bZr4TTU+HuPVtYXYC/Tl
         L3SyTj67jOA4poYVKgeqEznAXMniPXIDmdIdSvn6O2PHjSvpKlw+KHwNTkr7Z8dGqp
         Ji1VyYvm9gqLFxoj0fhxbBLS014M3W+0MBtJK/DyBOx95DPdajHY+z7rxNzfr5Tuo9
         6FqFV2Yk9jP86Y8lPph+9oEO6d83obb2Edc1S0w8jTWi+aw0ATMNKJtur+J6n5Ae4V
         LUvDc6b7Gs2Eg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw89: get channel parameters of 160MHz bandwidth
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220222032103.29392-1-pkshih@realtek.com>
References: <20220222032103.29392-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164578201482.10760.14181880178291276968.kvalo@kernel.org>
Date:   Fri, 25 Feb 2022 09:40:19 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> Calculate the offset of center and primary frequencies to get hardware
> indices of center channel and primary channel, and then use them to
> configure hardware to a specific channel.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

e715f10f3d05 rtw89: get channel parameters of 160MHz bandwidth

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220222032103.29392-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

