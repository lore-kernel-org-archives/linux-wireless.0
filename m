Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8985C001DF
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jul 2023 15:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbjGYPEX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jul 2023 11:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbjGYPDr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2023 11:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A74419B0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2023 08:03:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 099AF61782
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2023 15:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D516C433C7;
        Tue, 25 Jul 2023 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690297422;
        bh=zMu8gAZEXN+KC94t9iUXdhKA3+PWMh48QgURRoNKbDA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gakeKSMCL6k+XgPMxfyBdhYqodxw8Qi7gx6FW7fs/GxBsCQQi6SRGH4+mgA7P2Fdc
         rkvlXWbQXjGtepye0R/I1FGEHwMM7H7QXRDD2FR61dzqT085uJCR0Ipe9QIuPLROr+
         ZKp7wWyQy9FBgb9gosnu+dLufZEYdwHNNS0SwxKy7OPcDo4hIkOBzKPCtD7gFg7zN+
         GWxOanOojZiLK7gZZ5JMudNXqGDWbNcE94sIg/opJTIfKkTUHPwD7XlmrFHKHvmRsI
         ZqlpcX0S7qPB2ie2nUaAc8zfjALlYTnJPO3RZ3/63N9TkOL2SydYkS2SEIQen76nLi
         ahwmxuwqtXrfw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: wilc1000: remove use of has_thrpt_enh3 flag
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230710094401.235222-1-prasurjya.rohansaikia@microchip.com>
References: <20230710094401.235222-1-prasurjya.rohansaikia@microchip.com>
To:     <Prasurjya.Rohansaikia@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <Ajay.Kathat@microchip.com>,
        <Claudiu.Beznea@microchip.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169029741972.3309254.9562766790738793480.kvalo@kernel.org>
Date:   Tue, 25 Jul 2023 15:03:41 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Prasurjya.Rohansaikia@microchip.com> wrote:

> From: Prasurjya Rohan Saikia <prasurjya.rohansaikia@microchip.com>
> 
> The 'enhance throughput flow' algorithm is used by default. So older
> sections of the code are removed so as to always use this new algorithm.
> 
> Signed-off-by: Prasurjya Rohan Saikia <prasurjya.rohansaikia@microchip.com>

Ajay&Claudiu, can I get an Acked-by?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230710094401.235222-1-prasurjya.rohansaikia@microchip.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

