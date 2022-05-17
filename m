Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED8AC433F5
	for <linux-wireless@archiver.kernel.org>; Tue, 17 May 2022 10:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343887AbiEQKRe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 May 2022 06:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344929AbiEQKRP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 May 2022 06:17:15 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A826D4D276;
        Tue, 17 May 2022 03:14:35 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1652782473; bh=YrEZUatGpcW6tx9M6a5LX6XMkYrfUhXhCp7HQ5atufo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=TrXosL0UZZkkt6fgbk91csygw41EyeGqBPO2f0cbhR2uUJgC9DINRS7ou8/BH23sE
         XHIMAtA8Ni+ZFeQdICfmXbsMbNC/u4lT7JEFQ5Fdk7FjbXNdxYJrtbh9E4Unyk/fyk
         +KwfvycX5F184GS4qDFYApGLW3dmgQq8SRv3whpEjIc7y1ZuFkGCeM9exzmly6LzY0
         zy4ZyS1WopTWdsRyTgkmy3HomagWPwB3QycXz+L/DG9KKVqfH8nqd2ytCPMhvAiZDy
         Ehy6rYKsFo67oBWSg5SbKYrtUATZ6VbcHOapx2ZSrOih0JbyyoiTm1SgwlTtkkodtd
         5RbsJIH+0gn6w==
To:     Pavel Skripkin <paskripkin@gmail.com>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: Re: [PATCH v4 2/2] ath9k: htc: clean up statistics macros
In-Reply-To: <4456bd112b9d35f1cb659ed2ecc1c7107ebf2b91.1652553719.git.paskripkin@gmail.com>
References: <f158608e209a6f45c76ec856474a796df93d9dcf.1652553719.git.paskripkin@gmail.com>
 <4456bd112b9d35f1cb659ed2ecc1c7107ebf2b91.1652553719.git.paskripkin@gmail.com>
Date:   Tue, 17 May 2022 12:14:33 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <871qwscvp2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> I've changed *STAT_* macros a bit in previous patch and I seems like
> they become really unreadable. Align these macros definitions to make
> code cleaner and fix folllowing checkpatch warning
>
> ERROR: Macros with complex values should be enclosed in parentheses
>
> Also, statistics macros now accept an hif_dev as argument, since
> macros that depend on having a local variable with a magic name
> don't abide by the coding style.
>
> No functional change
>
> Suggested-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---

This patch doesn't apply; please rebase on top of the ath-next branch in
Kalle's 'ath' tree...

-Toke
