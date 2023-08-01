Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720E9C001E0
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Aug 2023 14:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbjHAOsR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Aug 2023 10:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbjHAOsQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2023 10:48:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D591BD8
        for <linux-wireless@vger.kernel.org>; Tue,  1 Aug 2023 07:48:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE3AA615CE
        for <linux-wireless@vger.kernel.org>; Tue,  1 Aug 2023 14:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C26FC433C7;
        Tue,  1 Aug 2023 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690901294;
        bh=fqSudnG8uVplZnRg0fqqpGBUgEkcZ4TtXKUFvofGWX8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EL55MSEgAA+Ad5vUByTXstWqlwF2Pdf7QFsFCtQHxMYTPvt1kFfLot8zsm8rnDq5j
         PzzlWURtVlQij8X3a8iA/Eii+e7w8TO2HIbanaiQF3RIHaHRIuy3tAW6y4fEibrGcw
         rrNW7j8TNe1RtmByiUUJ76PVQ7ypE3WehhwK0WxPtmH2Wcu07b2KOA1YNe1V+XAU+y
         cNHahgaFLDODqfkF3qCTrXdYYYKT9wH2qxl+5rf6BJ2u6gRHFr58D5EGaaE+4Quafx
         NKF0uuRUGQjhxzsHx5MOWuwoJzpP2u9ok/gJevUkSHrUyr9n4Lcg10lxJywqG2TlUY
         7iAhZTxJ9p93w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] wifi: wilc1000: add SPI commands retry mechanism
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230724163955.4583-1-amisha.patel@microchip.com>
References: <20230724163955.4583-1-amisha.patel@microchip.com>
To:     <Amisha.Patel@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <Ajay.Kathat@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Amisha.Patel@microchip.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169090129129.212423.6378280547713616733.kvalo@kernel.org>
Date:   Tue,  1 Aug 2023 14:48:12 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Amisha.Patel@microchip.com> wrote:

> From: Amisha Patel<amisha.patel@microchip.com>
> 
> In some situations like, chip wake-up with powersave enabled, SPI
> commands are failing temporarily. Reissuing commands after reset helps
> to overcome the failure. So, add the retry limit and reset command
> sequence API for read/write SPI commands.
> 
> Signed-off-by: Amisha Patel <amisha.patel@microchip.com>

Patch applied to wireless-next.git, thanks.

6fd879f9783b wifi: wilc1000: add SPI commands retry mechanism

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230724163955.4583-1-amisha.patel@microchip.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

