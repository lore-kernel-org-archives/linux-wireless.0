Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA335C001DF
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Aug 2023 18:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbjHBSW2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Aug 2023 14:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbjHBSWX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2023 14:22:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A30D210D;
        Wed,  2 Aug 2023 11:22:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8309D615A2;
        Wed,  2 Aug 2023 18:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B4FC433C8;
        Wed,  2 Aug 2023 18:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691000538;
        bh=k6zlk/SXcPQBtLc09TacuNY+GnZiEj/PHk1NLhVMyqM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WitrXYJI78qABabc/4CHRv8dtTAoDv50b/fYpKNNGRC6GGltMtT6vM2xDlwkuQVE2
         KKC9iU27lZ2NLfsuCxr/TWKTN4EXFaG4lD0ESi8t+0ecEyDBVMfznmKIBHehxqnvsA
         nJ42pXKK5NtyyS6QhJhEoy5Dh26wqxqTDyQCF9sq3qkNXomVKQc0rkU29tv/fp6YoP
         5BMJeJIuHNfHJTmwThv/Z/cEzH8h4z7YGmvaC36lYbqodJKh3TTxWcISxT5plb5Jc+
         rXW8PKMQNkgGzwefK45t+kHrn8hIcacVGL6bU7INL+J4iSO8AXBLTofp2Ag0D3ixTL
         PmFNsfiIe1Iqw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next v4] wifi: ath6kl: Remove error checking for
 debugfs_create_dir()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230726111209.4096-1-machel@vivo.com>
References: <20230726111209.4096-1-machel@vivo.com>
To:     Wang Ming <machel@vivo.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        opensource.kernel@vivo.com, Wang Ming <machel@vivo.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169100053440.669727.11474227932527205343.kvalo@kernel.org>
Date:   Wed,  2 Aug 2023 18:22:16 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wang Ming <machel@vivo.com> wrote:

> It is expected that most callers should _ignore_ the errors
> return by debugfs_create_dir() in ath6kl_debug_init_fs().
> 
> Signed-off-by: Wang Ming <machel@vivo.com>

This has been already applied:
https://git.kernel.org/kvalo/ath/c/1301783c8def

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230726111209.4096-1-machel@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

