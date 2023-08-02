Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01287C001DF
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Aug 2023 10:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjHBKNe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Aug 2023 06:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjHBKNd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2023 06:13:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F315132
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 03:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 037A9618D6
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 10:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6BFC433C7;
        Wed,  2 Aug 2023 10:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690971210;
        bh=fHpgO5NepXbBiqz3bHpeHshYkgx2RRX4BjOLlab2ldM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aL9viJMOpn4ofEZy+1VVI+4LNR00/3b6Y/tUY0daVevCW9e0QRGazHsC5hNqLoObi
         V2tRffK/xXfUsI20LyvNNLmzLhAwFT8MdorDa6iPfxrGzmoZoWAHjEliQmEvmabC1o
         wsGzIB3K+Yj4EqAtrPcnLPVppaCp+PFjO3XKtHxDO4fV5Zljp+1wkpMx77L3RjHBBU
         Z4gK7lR1g99lp5v9yqB5UrQUJeGGHwn2HC46/z6zSs0iFHxfOzEA9zwXTvcVdknyBJ
         fg9nNjOhYUMsr4X5/lsX0lPYZTlIqxzJCG4uG6TxMaGbVhXGqqqTwXgq4Sl/MlN+MX
         yHokae89l0Z+w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] wifi: brcmsmac: remove more unused data types
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230725162400.192357-1-dmantipov@yandex.ru>
References: <20230725162400.192357-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169097120719.265879.2033564344159564058.kvalo@kernel.org>
Date:   Wed,  2 Aug 2023 10:13:29 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Remove unused 'struct brcmu_iovar' and 'struct tx_inst_power'. This
> follows commit b2090d93d4b6 ("wifi: brcmsmac: remove unused data type").
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

2 patches applied to wireless-next.git, thanks.

a9477c12ae54 wifi: brcmsmac: remove more unused data types
0701519fda6f wifi: brcmsmac: cleanup SCB-related data types

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230725162400.192357-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

