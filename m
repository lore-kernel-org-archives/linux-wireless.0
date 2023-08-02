Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FF9C04FDF
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Aug 2023 11:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbjHBLwu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Aug 2023 07:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbjHBLwt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2023 07:52:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2CFE5F
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 04:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40AFB61940
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 11:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E33C433C8;
        Wed,  2 Aug 2023 11:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690977161;
        bh=LhatR+4gUqZ9tg6uuemdz8z4n+BTkpM1ivLr0jsuUkA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Z8Chz5kZTdNRugiAdoV651GLaWM/IApgDxfF1qYbtWWCTHQcR5wNUvwoN1SRAnAgF
         HaWMy3w6e2fVwPpTBkKYqLvFfdDshBpy4y9VuLt7KGRo7KFZ4az4ovxcb9/I/gAWVd
         sMER6PMz94xZOOQ46PEAqbZFcNqVu/Yk+R/YiXvyJ3egvOt8YoawKMO8N7ZKSmoZjF
         Wh1/V6Z4eUPCQP22Rj+6pkYYteHZgZZLGFooDY5vyEe7f1axTnnzcCW7/DwgtR5eVl
         n/X05LicALMc69ctviKSxx3hTwCwrWK3VbsqtblmHcOY7cPCCxM846jS6hhLB8yE1A
         6aLl3HmLNu4/w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: simplify
 ath11k_mac_validate_vht_he_fixed_rate_settings()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230726092113.78794-1-dmantipov@yandex.ru>
References: <20230726092113.78794-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Ziyang Huang <hzyitc@outlook.com>, linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169097715860.457012.1798638161503800650.kvalo@kernel.org>
Date:   Wed,  2 Aug 2023 11:52:40 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> In ath11k_mac_validate_vht_he_fixed_rate_settings() ar->ab->peers
> list is not altered so list_for_each_entry() should be safe.
> 
> Compile tested only.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

6f092c98dcfa wifi: ath11k: simplify ath11k_mac_validate_vht_he_fixed_rate_settings()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230726092113.78794-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

