Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC70E7AD52
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Oct 2023 14:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbjJCOVn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Oct 2023 10:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239596AbjJCOVl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2023 10:21:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAB2BB
        for <linux-wireless@vger.kernel.org>; Tue,  3 Oct 2023 07:21:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE83C433CA;
        Tue,  3 Oct 2023 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696342897;
        bh=2AUmMWH+IOOl9AtUReDwtvY3zALHVI8J7LBLFa+FHMI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TaA+86Q2sz3C04lNWcZ0r5SFYJWnPH1+wtHyi5SzLn+Q5BYMkD2lw75Okfwd1jY7L
         Gf4so6nSPh6WHUUrjt6lzeOvFsAXq0ak2B8mSaXAbE4kTiOEhzXCt/y3cp4k9oNuf+
         QjzcnF78wPueDNZG5PEKM/fKGoUvXtjRPaRCcGbZZN2LyCs1Nd8J6vB24eXGG05cAI
         N6EfBaMrWMbDVYOSsq6bXypxll1JRp/tUHSvKGNh38gZgpmsm6tXdAPHF7W+jm85XA
         nWbccjgh7zZ5xi7jDRkkIZ9/CxCjTZaGrSn2rfOSCvIiRCpJs0spsDrQ07rHRXaVoN
         nJtk/pLhwBx4Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath10k: simplify ath10k_peer_create()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230704180617.84948-1-dmantipov@yandex.ru>
References: <20230704180617.84948-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169634289494.61956.18320291345031204017.kvalo@kernel.org>
Date:   Tue,  3 Oct 2023 14:21:36 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Use convenient 'list_count_nodes()' in 'ath10k_peer_create()',
> thus making the latter a bit smaller and simpler.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

322a487c53f8 wifi: ath10k: simplify ath10k_peer_create()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230704180617.84948-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

