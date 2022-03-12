Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF2AC433EF
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Mar 2022 01:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiCLBJo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Mar 2022 20:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCLBJo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Mar 2022 20:09:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387C040A3F;
        Fri, 11 Mar 2022 17:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E800CE2986;
        Sat, 12 Mar 2022 01:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD624C340E9;
        Sat, 12 Mar 2022 01:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647047315;
        bh=U/onqElJLVCJgmOdHzEApWa2fLZ6/41EGE/qkLVwDIY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oVWxPeY10MihDc5dQDd10a3b+aUm+22we0PVP+mSLZDy/E+sKx62XwfAhbObSfl0C
         /fOtzaRANS82elm/44PmU0pbDUWzTyK1laCFdsI3WIoq9eqmp0BBRDwlvu8pHXB051
         VD6dTRqVQf3Hh2XXCePg1OFmBlZSoMnAgzq9MzAYYanRB+Q/Uuj9a2e12Q+Ob8SRuY
         Mz9RAEw5mqKZDUpoW0vPrdqDqvVO7A3AeQunK0DTkJgiXt+xPI8w9rnYKxhZxpQsgR
         rwTqolsmVeD7YWJ+fQ4SwAkrbbsax1eRfCwWm+QMk7BveKXH2S7+yA4QnLafxF5HW1
         UI3lFmG2rd4wQ==
Date:   Fri, 11 Mar 2022 17:08:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-03-11
Message-ID: <20220311170833.34d44c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220311124029.213470-1-johannes@sipsolutions.net>
        <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
        <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 11 Mar 2022 17:06:25 -0800 Jakub Kicinski wrote:
> Seems to break clang build.

No, sorry just some new warnings with W=1, I think.
