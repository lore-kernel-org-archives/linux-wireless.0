Return-Path: <SRS0=USiB=VJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD649C742AE
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jul 2019 09:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC89A21537
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jul 2019 09:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfGLJMP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Jul 2019 05:12:15 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55382 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfGLJMP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jul 2019 05:12:15 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hlrbB-0006Oq-HU; Fri, 12 Jul 2019 11:12:13 +0200
Message-ID: <5a2f1cd759593a66c4c5ad5ec421587c5c105b8f.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 1/2] cfg80211: refactor cfg80211_bss_update
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Mikhail Karpenko <mkarpenko@quantenna.com>
Date:   Fri, 12 Jul 2019 11:12:12 +0200
In-Reply-To: <20190710173651.15770-2-sergey.matyukevich.os@quantenna.com>
References: <20190710173651.15770-1-sergey.matyukevich.os@quantenna.com>
         <20190710173651.15770-2-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-07-10 at 17:37 +0000, Sergey Matyukevich wrote:
> This patch implements minor refactoring for cfg80211_bss_update function.
> Code path for updating known BSS is extracted into dedicated
> cfg80211_update_known_bss function.
> 

Looks good, thanks for splitting this out.

I'm not going to apply anything until net-next also opens up again
though.

johannes

