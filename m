Return-Path: <SRS0=o+Lw=VU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEEDC76190
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Jul 2019 05:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDFD72238C
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Jul 2019 05:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732622AbfGWFHh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Jul 2019 01:07:37 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46958 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732478AbfGWFHh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jul 2019 01:07:37 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hpn1Q-0006JY-Jl; Tue, 23 Jul 2019 07:07:32 +0200
Message-ID: <262fc08905febd29f9abd0870dbe674fcc5bfb3e.camel@sipsolutions.net>
Subject: Re: nl80211 wlcore regression in next
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tony Lindgren <tony@atomide.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Eyal Reizer <eyalreizer@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Date:   Tue, 23 Jul 2019 07:07:31 +0200
In-Reply-To: <20190722130213.GN5447@atomide.com>
References: <20190625073837.GG5447@atomide.com>
         <2570f4087d6e3356df34635a0380ec8ce06c9159.camel@sipsolutions.net>
         <20190625080019.GH5447@atomide.com>
         <7f74087fef1e554e0aeb82a6cec4113727487928.camel@sipsolutions.net>
         <20190722130213.GN5447@atomide.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Looks like this one crept back as the fix is missing from v5.3-rc1.
> 
> Forgot to include in the pull request?

More like forgot to send the pull request, my bad. I eventually realized
a couple of days ago and it'll be coming upstream soon. Sorry about
that.

johannes

