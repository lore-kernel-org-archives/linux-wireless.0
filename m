Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB6CC001DC
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jul 2023 15:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbjG0Pze (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Jul 2023 11:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbjG0Pzd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2023 11:55:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD87BC;
        Thu, 27 Jul 2023 08:55:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF42461EBA;
        Thu, 27 Jul 2023 15:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA1FC433C8;
        Thu, 27 Jul 2023 15:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690473332;
        bh=DAdNaKTtTBA/3Io3SkqTp38JscNchiNy5CKdvBKYCIo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FK7DCDQaWv3SyLv/v3DAAAeo6JWudkm4nUty4dSq1TMFlFG2grAFXd8fZlsNY8VGi
         ejW/DUCHSdxaP0RxZSjrCTfhjXUYuPNItrHuD17dO59vYGEEbsT54YmgcpkfwbBu3z
         0ITnNqZimChffFAOsdSE9z/v9+oj0eIoI4VxwZJQdVla4oBJdRhqlcNQLF4ARBviIN
         V5/2ryMTFAP0ndB1fbcYc52QGYQTWgnn6OwI7/xZe3Yrrdl2tEKoqy9GViOnXTaTwB
         puBKZk3+buOKT5AAuwX4UddLBRcrJDrQAxlMFtSA4Sdakyi/J2LRFlbF27XLlvvhrB
         y55QVttcSHo7g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Wang Ming <machel@vivo.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        opensource.kernel@vivo.com
Subject: Re: [PATCH net-next v3] wifi: ath9k: Remove error checking for
 debugfs_create_dir()
References: <20230726110750.3925-1-machel@vivo.com>
Date:   Thu, 27 Jul 2023 18:55:28 +0300
In-Reply-To: <20230726110750.3925-1-machel@vivo.com> (Wang Ming's message of
        "Wed, 26 Jul 2023 19:07:39 +0800")
Message-ID: <8735191h8v.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wang Ming <machel@vivo.com> writes:

> It is expected that most callers should _ignore_ the errors
> return by debugfs_create_dir() in ath9k_htc_init_debug().
>
> Signed-off-by: Wang Ming <machel@vivo.com>

ath9k patches go to ath-next, not net-next. So do *not* put net-next
into Subject. No need to resend because of this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
