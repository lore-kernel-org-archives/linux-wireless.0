Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FA0C43462
	for <linux-wireless@archiver.kernel.org>; Tue, 11 May 2021 12:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4055B6186A
	for <linux-wireless@archiver.kernel.org>; Tue, 11 May 2021 12:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhEKMFu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 May 2021 08:05:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34872 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231538AbhEKMFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 May 2021 08:05:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5u2lW8RKz8/Z3PJTIiHXnNaU9wBSRgfqwolanPIUe8Y=; b=RoAPO8hC9Tz7/mkjSljO3QEuHe
        gSA4/K7SZtCZ5m/cr4u09PjrjVDc56+Ez1S3Uz4vELPR9vkzxoS/ywHTYBOf3OvrdEE/Z4NQfxB9W
        jv4rIu8lEskUxwz99sE+555MaWrn41DzFSbHRPt38gTG95XaP88fcV4vErLP+e5YLA0Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgR7e-003jM0-8X; Tue, 11 May 2021 14:04:22 +0200
Date:   Tue, 11 May 2021 14:04:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] b43: phy_n: Delete some useless empty code
Message-ID: <YJpyxtsmj1upSpQE@lunn.ch>
References: <20210510145117.4066-1-thunder.leizhen@huawei.com>
 <YJmRUQwPPDE+hWiN@lunn.ch>
 <1890aa92-ddf2-78f7-51e7-bdc3a58a04c6@huawei.com>
 <c7c7c332-acc3-4907-1c7d-ccf2413ef837@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7c7c332-acc3-4907-1c7d-ccf2413ef837@huawei.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> I got it. It reported by W=1.

A lot of the kernel tree is W=1 clean now. Networking is. So we expect
patches to also be W=1 clean.

Hopefully this will become the default at some point, or the
additional warnings W=1 enables will be made always be enabled.

	   Andrew
