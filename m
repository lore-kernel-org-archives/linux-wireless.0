Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952A0E732DB
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Sep 2023 14:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjI1OZs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Sep 2023 10:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjI1OZr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Sep 2023 10:25:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6950BF5
        for <linux-wireless@vger.kernel.org>; Thu, 28 Sep 2023 07:25:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888E9C433C8;
        Thu, 28 Sep 2023 14:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695911146;
        bh=SscX0eVTadFaC933RGYn5MMrw3xERy23VuqySk0yQlg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KFHUaYkuvUth8LZbhakdv9ORlVLuVTqBg6mUa5xLXFIJcGFcjUwEr3JMzwgfHzbpu
         p7IxER2pMPwRN8hC9XD2XdF0lrptzBMjlB9Bz9roQtwHnnnjceE3UpCwXszJlcB3Ow
         7olK7g9nxNkr9QzZCWTfNLLehvQG0jyNdiWFqrwPYMgbBiPu7xyk7GegHN12kbWT57
         3gKngEuQQKy5Kc+zouuxunmXZpaFruBkQWcZDOR7PoR0SaWqoPXuywwyERI4yHe2jO
         kEtwvYMP3NNznqByq7ZOy2oH+x6OuNcAQVtR0gBOBxIrwPtGQjegBK79Mm3iJ6wbbg
         hIKq0Oxq8doQg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/5] wifi: ath11k: use kstrtoul_from_user() where
 appropriate
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230824075121.121144-4-dmantipov@yandex.ru>
References: <20230824075121.121144-4-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        lvc-project@linuxtesting.org, ath11k@lists.infradead.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169591114235.3019228.10330000472453318996.kvalo@kernel.org>
Date:   Thu, 28 Sep 2023 14:25:44 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Use 'kstrtoul_from_user()' in 'ath11k_write_file_spectral_count()'
> and 'ath11k_write_file_spectral_bins()'
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

458f66c30df2 wifi: ath11k: use kstrtoul_from_user() where appropriate

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230824075121.121144-4-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

