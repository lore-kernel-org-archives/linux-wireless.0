Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5644BC0015E
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jul 2023 15:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbjGYPQr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jul 2023 11:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbjGYPQo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2023 11:16:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11540122
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2023 08:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E37F61796
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2023 15:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE79C433C7;
        Tue, 25 Jul 2023 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690298201;
        bh=/bmSZKReqdijKEk+r27HMv8oJltVtemVQtTLF/O6O5U=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=oXE92mkAaq4R9tCTx/UTL4E1OiYoB/CCtsLx6k6KSdreuqRFQRTF0EjIutikM4Ug+
         23Eyl1Hyh2maHypXE5UWj+B1hN6IDH0AA2a6vkYrnDPXzYBCcWbvySeEaZrsu0EAns
         7miVmbXHgD/xFus9GqJvuf4upI2gAeed7vNvHZy+VIzV9mNLZOq8y4ohQAzIPj6uWS
         tA1TzpLnm/3KS2T7qsOJu/c8MqgUJvhjk8uQPVd9+qJrAfnuWL35ifNXAyvTWGABmd
         VdDYC9f7lQaTu7qbx9AN60CpG3Ks3sKybFyy/i+qN3iXCnzV5CqTKIwf+ERt/Z5Pz4
         NggdqWXsg6vfg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: brcmsmac: remove unused data type
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230719083232.158177-1-dmantipov@yandex.ru>
References: <20230719083232.158177-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169029819901.3309254.8488161920934421780.kvalo@kernel.org>
Date:   Tue, 25 Jul 2023 15:16:40 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Remove unused 'struct gpioh_item'. It seems it was so since
> commit 5b435de0d786 ("net: wireless: add brcm80211 drivers").
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Patch applied to wireless-next.git, thanks.

b2090d93d4b6 wifi: brcmsmac: remove unused data type

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230719083232.158177-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

