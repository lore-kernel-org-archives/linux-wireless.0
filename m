Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D5ADC0015E
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Aug 2023 10:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjHAK0q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Aug 2023 06:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbjHAK0J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2023 06:26:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E701930EF;
        Tue,  1 Aug 2023 03:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E87EA61539;
        Tue,  1 Aug 2023 10:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33556C433CB;
        Tue,  1 Aug 2023 10:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690885041;
        bh=uKQHNBewgHF9nEvZqJ3rqmkkqgDwBDK4hB+7/BHEJjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EIpAm0nEG3Jpp1/Pi6Bswkiqze6qEHlxde0uYIp3NVvJ+KY5i/Zz/oHoiKePWLeYW
         Z1wB7kkLjYxLz+SMbs3CRU3xMSUmhQn8ggxG3ZgjEhk54UXd4uRYSIpsiZ53Kpu7nd
         SmG0PHcG0bGy509Jp7KtxNasH1PGeYgaURi092slILzeK1Oyqxg4LT+ZDKtJ7CuE2G
         Y9rPMor1n1uuAMu7UknoT5EcWkAxncrqVcB53MZl/rVVJE+jFh4G7bWh3LOmzCUrlc
         QWm38ysQG92kRdspNaszvfyBDOoi8ZRdqtbTM/yFN1yWeaLi1qJiqZwzfSxkMWGGv+
         +TW6SJngdwyGQ==
Date:   Tue, 1 Aug 2023 12:17:17 +0200
From:   Simon Horman <horms@kernel.org>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nbd@nbd.name, pagadala.yesu.anjaneyulu@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211: mesh: Remove unused function declaration
 mesh_ids_set_default()
Message-ID: <ZMjbrQWaXU+qpEQe@kernel.org>
References: <20230731140712.1204-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731140712.1204-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jul 31, 2023 at 10:07:12PM +0800, Yue Haibing wrote:
> Commit ccf80ddfe492 ("mac80211: mesh function and data structures definitions")
> introducted this but never implemented.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>

Reviewed-by: Simon Horman <horms@kernel.org>

