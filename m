Return-Path: <SRS0=5Iat=VC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD0FC5B57D
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Jul 2019 08:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63C87218BC
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Jul 2019 08:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfGEIvs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Jul 2019 04:51:48 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:39200 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726427AbfGEIvs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Jul 2019 04:51:48 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hjJwR-0000l5-Df; Fri, 05 Jul 2019 11:51:41 +0300
Message-ID: <1205f44d3a0e6470cff15334da64c49ebf49002e.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Alexander Wetzel <alexander@wetzel-home.de>,
        johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 05 Jul 2019 11:51:38 +0300
In-Reply-To: <20190629195015.19680-4-alexander@wetzel-home.de>
References: <20190629195015.19680-1-alexander@wetzel-home.de>
         <20190629195015.19680-4-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/4] iwlwifi: Enable Extended Key ID for mvm and dvm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-06-29 at 21:50 +0200, Alexander Wetzel wrote:
> All iwlwifi cards are able to handle multiple keyids per STA and are
> therefore fully compatible with the Extended Key ID implementation
> provided by mac80211.
> 
> Allow Extended Key ID to be used for all mvm and dvm cards.
> 
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
> 
> This is basically the v2 patch of https://patchwork.kernel.org/patch/10931879/
> which Luca still has in his review queue. It just uses the new proposed
> simplified Extended Key ID API from this patch series instead.
> 
> Merging (parts) of this series will of course break the older patch
> still queued to Luca, so this may need some coordination.

Thanks for your patch! I've dropped the old version and will wait until
Johannes merges the mac80211 part (and it reaches wireless-drivers-
next), so I can apply this.

--
Cheers,
Luca.

