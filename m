Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B65FC433FE
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Mar 2022 15:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242005AbiCPPck (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Mar 2022 11:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347783AbiCPPcj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Mar 2022 11:32:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CEC6D189;
        Wed, 16 Mar 2022 08:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93132B81C15;
        Wed, 16 Mar 2022 15:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BACC340EC;
        Wed, 16 Mar 2022 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647444681;
        bh=R7sCQbSzVl5A3Wy1tLt63Lz64KpJQdnHDuySp8qFbnQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JEzDy27aijMEEj2tEznLcFFWRsvBrqN65lC/OXehQ2vE+Ia2EyQ6597kJo7h9yFUH
         JYyvZ3jsHVaur5C5uflUG0pQEYjjNSDfOHt1AJ+b9UxmxCTwe6gzPh7M1K5+7j4xop
         e2tCTGtdrdvSwUsaQ9Vn2xMAMZPl7h7Z9WVcWA/j20Dz7QcO5Ew/J+BEHInfSto4+M
         7Vx8EoTSC65oCjzMK6MFPJLyuXvdMprFUkPwXlnw1emb62TcWyrxAvQ0ZmhAZ8rPfR
         +43HR312LX2nBZjIz24XZoHt5mZ+/2P8/QziCQmFQxY7P8hylwoS55Tu74bqCAzZuU
         DXQrZPOzSrcag==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 19/30] rtlwifi: rtl8821ae: fix typos in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220314115354.144023-20-Julia.Lawall@inria.fr>
References: <20220314115354.144023-20-Julia.Lawall@inria.fr>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164744467499.16413.6184144924989556392.kvalo@kernel.org>
Date:   Wed, 16 Mar 2022 15:31:19 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Julia Lawall <Julia.Lawall@inria.fr> wrote:

> Various spelling mistakes in comments.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

2 patches applied to wireless-next.git, thanks.

31f8bef8acab rtlwifi: rtl8821ae: fix typos in comments
bfbd78cfdd62 airo: fix typos in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220314115354.144023-20-Julia.Lawall@inria.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

