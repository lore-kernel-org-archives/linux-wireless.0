Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EADC10F01
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 10:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 787CB21736
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 10:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbfBRK0G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:26:06 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:58884 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729359AbfBRK0G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 05:26:06 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gvg7d-0005au-SE; Mon, 18 Feb 2019 18:26:01 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gvg7Y-0005ml-5B; Mon, 18 Feb 2019 18:25:56 +0800
Date:   Mon, 18 Feb 2019 18:25:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, j@w1.fi, tgraf@suug.ch,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [v3 PATCH 0/4] mac80211: Fix incorrect usage of rhashtable walk
 API
Message-ID: <20190218102555.rsybk7ez73k2u6vp@gondor.apana.org.au>
References: <20190213050551.x3jffq3ipghw6g2m@gondor.apana.org.au>
 <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
 <20190214140236.omt74prxhkfaasue@gondor.apana.org.au>
 <52bdb66f7e9e26ce9225ae11e37e22766d73694d.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52bdb66f7e9e26ce9225ae11e37e22766d73694d.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Feb 15, 2019 at 01:21:55PM +0100, Johannes Berg wrote:
> 
> Applied those now, I'll send a pull request to Dave with them. Once that
> trickles back into net-next I'll apply the third patch (it doesn't apply
> without the others), and then Dave you can take the rhashtable one.

Thanks Johannes.

> Let me know if you'd prefer I take the rhashtable one through my tree,
> which really would be only so you don't have to track the dependency.

I don't mind.

> NB: it'd be easier in patchwork if you tagged all the patches with v3 in
> their own PATCH tag, or put the "v3" tag into the actual subject (not
> the "[PATCH 0/4]" tag because evidently patchwork drops the tags and
> doesn't track them for the *series* just each *patch* ... so with what
> you did nothing is visible in patchwork, even just appending "(v3)" to
> the subject of the cover letter would've fixed that...

Noted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
