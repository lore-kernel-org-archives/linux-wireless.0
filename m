Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7DFC282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 08:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88903222B5
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 08:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388580AbfBMIEb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 03:04:31 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:37202 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfBMIEa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 03:04:30 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gtpWn-0001pS-CY; Wed, 13 Feb 2019 09:04:21 +0100
Message-ID: <6b0e066f05fa8c78a2e6850dbece388533a223d1.camel@sipsolutions.net>
Subject: Re: linux-next: Tree for Feb 11 (wireless/80211)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Wed, 13 Feb 2019 09:04:20 +0100
In-Reply-To: <80b32344-08c9-0d8b-fdae-1db9b1003f60@infradead.org>
References: <20190211183951.3fe1dad9@canb.auug.org.au>
         <80b32344-08c9-0d8b-fdae-1db9b1003f60@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Thanks for the heads-up, Randy. We'd seen separate build bot reports on
this as well.

> ERROR: "__umoddi3" [net/wireless/cfg80211.ko] undefined!
> ERROR: "__umoddi3" [net/mac80211/mac80211.ko] undefined!

Should be fixed as of yesterday, let me know if it reappears.

johannes

