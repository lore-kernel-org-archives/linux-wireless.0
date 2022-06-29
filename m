Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3348C43334
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Jun 2022 17:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiF2RXv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiF2RXu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Jun 2022 13:23:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A8B3AA75
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2022 10:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D7B61E6B
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2022 17:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9618FC34114;
        Wed, 29 Jun 2022 17:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656523428;
        bh=xs/Lqgyx5FFOD63X8pM6z/doS8JTwg9dhODrHygMy2M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZdbzF5xB8xWEAJKUw1XvQv9zftzqK43L5VryKjBhfUe9C9WsIr3ZoHCD0j82FUoBx
         dyS3B2giyaVv2K1L72+1+5DE5lI0G2rO5puovp7sItoI5P8Xim0HCAXj+6MohH1PrO
         r4KymnJwaDz171rVzV3B21LVR3d/tyVlfEbSBTjRlubI4ye0wZ6uqw4BY1+aJnlXPi
         p9nm5m3Lebc9Z5prhMdZgNCOWd2R881fCz3tQAgstwWUU0OF3hI0BbQhZ7DAenyKj5
         VosVfemVOl5boPyp6yZP9sYoKYJ0z6UdxtWyZggCD8RPT/Pb1bJ7BbydVc1Jk0W+D8
         oxtdUgmdpvyZg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Vinayak Yadawad <vinayak.yadawad@broadcom.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        jithu.jance@broadcom.com
Subject: Re: [PATCH 1/1] cfg80211: Allow P2P client interface to indicate successful 4way handshake by port authorization
References: <ef25cb49fcb921df2e5d99e574f65e8a009cc52c.1655905440.git.vinayak.yadawad@broadcom.com>
Date:   Wed, 29 Jun 2022 20:23:42 +0300
In-Reply-To: <ef25cb49fcb921df2e5d99e574f65e8a009cc52c.1655905440.git.vinayak.yadawad@broadcom.com>
        (Vinayak Yadawad's message of "Wed, 22 Jun 2022 19:17:39 +0530")
Message-ID: <87a69vpen5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Vinayak Yadawad <vinayak.yadawad@broadcom.com> writes:

> This electronic communication and the information and any files transmitted 
> with it, or attached to it, are confidential and are intended solely for 

These kind of disclaimers do not belong to public lists.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
