Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE56C433EF
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Apr 2022 15:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbiDFPSR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Apr 2022 11:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235722AbiDFPRF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Apr 2022 11:17:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253A1524349;
        Wed,  6 Apr 2022 05:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7CCCB822B2;
        Wed,  6 Apr 2022 12:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B897C385A1;
        Wed,  6 Apr 2022 12:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649247406;
        bh=bBXDw64UOpzm7gZgO/Usb8R7Vc4waEovDX6UsSvLe3g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TU8cYii2k0J2zHNl4T9PTAmCaJOM13yuwVdi5EFGMICiq8qSTUcCJzR4M7cbAs7eb
         V+I9jZbPnxr3rFimLi5uA0dvNZy/wLv5S3cMruztrzOp+cU58JhkZjPMw64maGu7bA
         UYd7gvFo/xSvinA4dfkrqha9GRcYBeD2xqp0YAs2PvUWBEoWJlvaiDxz0u1itEuKwJ
         sLcmBdc4amKVW1tDuQMWxE0zY4mnqttGW2aQROYTnbda/6gF2IyzOOsyMWZ9SRF8Ro
         vV8GtmvcUCrfqHg3gndsqYIfXBdAvd2DBuLhKMMoTSeJKQROwm86Vr0SNSjDC6EETC
         Q8aAvcvPQlFXg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net] ipw2x00: use DEVICE_ATTR_*() macro
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220406015444.14408-1-tangmeng@uniontech.com>
References: <20220406015444.14408-1-tangmeng@uniontech.com>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924740245.19026.7090113247090845414.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 12:16:44 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Meng Tang <tangmeng@uniontech.com> wrote:

> Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
> 
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>

Patch applied to wireless-next.git, thanks.

92bbf95df768 ipw2x00: use DEVICE_ATTR_*() macro

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220406015444.14408-1-tangmeng@uniontech.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

