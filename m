Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E90C4332F
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Dec 2022 18:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbiLUSvR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Dec 2022 13:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiLUSux (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Dec 2022 13:50:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2C52AD5
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2022 10:50:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97F1C6189B
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2022 18:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB87C433D2;
        Wed, 21 Dec 2022 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671648648;
        bh=so/1GqXGZFiqSNf2UD6Uj5xOXKjJAR+nzRrIu7dJBHo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=L59s2TfJcwu0DCf+4DwjimwX3XZjCtZ4Ws/PE3v4W7IRYMxCtqYKamAou7w+hQREI
         Y4QcxY7b1oKYtP0Ge4naVM+ulw6pj91YyCQLyO0barUfnavkavexsAEF5b+Vvrfg0o
         IGVwBCHZgU/X5YIFVc0fVVsjfEpt+juS9k2ef0q07Z9XAetq0UIR6tay2DZQ4CwjKE
         il5ZvNkn/ziW8lrqe33RKZYxgeIASaecOkeXRpccQyOjqjiTBpc8jmqj5WcZZRi6Vt
         OAvMYTzBF1GoYRHz1M4dqFjBUe7K/v56Nqon2R54ZXUVDuAVYYdMQP3ObqMGlDkNSE
         t3lq+0uFC9kTQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw89: refine 6 GHz scanning dwell time
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221214091952.42792-1-pkshih@realtek.com>
References: <20221214091952.42792-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <phhuang@realtek.com>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167164864539.5196.15937236024136116262.kvalo@kernel.org>
Date:   Wed, 21 Dec 2022 18:50:47 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Po-Hao Huang <phhuang@realtek.com>
> 
> Reduce dwell time to improve scan duration in 6 GHz. This is required
> for scan requests that does not include RNR parsing and does full
> channel scan.
> 
> Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

08c93c0ca74c wifi: rtw89: refine 6 GHz scanning dwell time

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221214091952.42792-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

