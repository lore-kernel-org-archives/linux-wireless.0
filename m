Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8962ECAAD8
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Sep 2022 10:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbiIUKST (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Sep 2022 06:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiIUKSQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2022 06:18:16 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A23495AEC;
        Wed, 21 Sep 2022 03:18:15 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1663755493; bh=41XcwKKXbTueP4NKKCKH4lAY+pFFUeOnqxXy3lPn1ug=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lJguM4Tas+94MZ4o+K6U+S6b3KtF/3NGs7bLIX8xdqGg2wleZiEeAjQjbyyRKkef5
         FgueoQrNLlJAX9L8fz3Jl9aN6I19w/xKfjuKuJL0nsMiQqKPa45KFWLaq/Q/Z4EdxH
         4kVCgjxbbj+5D+QP9l5NJu2yoZXTbS3rOJicJ03HMCLZCUSOMv+SeSMZ6sMd552xMc
         0sO63E8uYEMRwZSc+JTB2RUa0cq6zcVF3GK6ctVm/h+bUUbAXkaoApZZZnwy4wWuZ4
         rkht3utd+mrPBlERzQuDVD5FailtpGpD8sIrofhs0E5dNsUWLfd1zorxArMjx35Boo
         8NClFG+kSd2Rg==
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: Re: [PATCH] ath9k: fix repeated words in comments
In-Reply-To: <20220915030559.42371-1-yuanjilin@cdjrlc.com>
References: <20220915030559.42371-1-yuanjilin@cdjrlc.com>
Date:   Wed, 21 Sep 2022 12:18:12 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a66tvxnf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> writes:

> Delete the redundant word 'to'.
>
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
