Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EE7C77B70
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Apr 2023 10:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjDQKWB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Apr 2023 06:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQKWA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Apr 2023 06:22:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B4410D
        for <linux-wireless@vger.kernel.org>; Mon, 17 Apr 2023 03:21:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C72E621E2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Apr 2023 10:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3C2C433EF;
        Mon, 17 Apr 2023 10:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681726746;
        bh=HM9nC8PljvBOotxdB6u1S7tyFSUTY+vaSTJETjjfhr8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jEQUt1Ic7aUNjQ1OCKF0RRsXmLvv7TE3wot+pjLVb01tb3pxtua6Yv8zvwseo5W0u
         /OJ4X7Wp8cKODn75vEi0baFsFxpmVKY/K604t9d0eY6sx6lL2o8rx3OnV5xw/BMePd
         dPEYix6SCterJR9xbD1p7yri7Y/w7ilG3IBTJERFnC/eaQFQxFvP5Sm+1TduGzwGcn
         2N/Ryqx1rLGx9uYUftqDUYafjj1Cs2ZBjFFrp2nV3gxYOzRWU9mlOkSgapp2bova0i
         YDobCX+aHKhobRtDKY67pRVjaNoSKJv6Fqnlle1sQxjM34PR1kU9EC8k9UIEwFPgGo
         oqh1NGtsXkZeg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: print a warning when crypto_alloc_shash()
 fails
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230405090425.1351-1-kvalo@kernel.org>
References: <20230405090425.1351-1-kvalo@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168172674407.12889.5186313051600365683.kvalo@kernel.org>
Date:   Mon, 17 Apr 2023 10:19:05 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@kernel.org> wrote:

> Christoph reported that ath11k failed to initialise when michael_mic.ko
> module was not installed. To make it easier to notice that case print a
> warning when crypto_alloc_shash() fails.
> 
> Compile tested only.
> 
> Reported-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/all/20221130133016.GC3055@lst.de/
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

a87a9110ac0d wifi: ath11k: print a warning when crypto_alloc_shash() fails

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230405090425.1351-1-kvalo@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

