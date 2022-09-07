Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C04C6FA8C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Sep 2022 08:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiIGIAx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Sep 2022 04:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiIGIAl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2022 04:00:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414265071F;
        Wed,  7 Sep 2022 01:00:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D401E615FC;
        Wed,  7 Sep 2022 08:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C8BC433B5;
        Wed,  7 Sep 2022 08:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662537639;
        bh=QBqwKvr0O1/H8f5NlSJlsM2t7ip7n9qToMpPyjgEBho=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SCtyPwlZIQx9XS/noPjcVxrfGEHBDisTtrUzT4RorXLno0S1CCwUoK9ASFw/5fvrZ
         g7ddpnSF9hOy/hWjIMJb/oJaQ3ToZC6pI7nDP55ON+/aqWp2QVffzyUM0n3zS9iWap
         P5wQoLbdOOdUpCrkRXeQnGZhQyPKwmVd5p0FJc+XjCvvz05EToRew+17UFdR8Oe6jQ
         /Pnh/J6q59oPjxRn5bkA3pnKe9wKui+dwsHSXljJKP9xEe40TP5xq9S5T+cbmPNWLw
         8k+aP0A2CI8T1b6nDK0ulB9BRG5fZcQIIzc8EWX4fgEcq4PhF0nz5BTw9frVbxY2rL
         CU7mIdhzyBWzw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] bcma: Fix typo in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220811152043.11446-1-dengshaomin@cdjrlc.com>
References: <20220811152043.11446-1-dengshaomin@cdjrlc.com>
To:     Shaomin Deng <dengshaomin@cdjrlc.com>
Cc:     zajec5@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shaomin Deng <dengshaomin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166253763613.23292.13993862811761388522.kvalo@kernel.org>
Date:   Wed,  7 Sep 2022 08:00:37 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Shaomin Deng <dengshaomin@cdjrlc.com> wrote:

> Remove the repeated word "registers" in comments.
> 
> Signed-off-by: Shaomin Deng <dengshaomin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

5db68fd31958 bcma: Fix typo in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220811152043.11446-1-dengshaomin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

