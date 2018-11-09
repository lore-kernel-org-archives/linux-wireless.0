Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7678C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A23920818
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:19:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A23920818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbeKIVAC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:00:02 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56458 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbeKIVAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:00:02 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gL4pK-0003BS-DG; Fri, 09 Nov 2018 12:19:50 +0100
Message-ID: <37faa3760d0b2d9e3aa5c13de283763838e58c20.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow hardware scan to fall back to software
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        sushant kumar mishra <sushant2k1513@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Date:   Fri, 09 Nov 2018 12:19:48 +0100
In-Reply-To: <CANGSkXSox2BquGzhXzALtLxVe8nY67iOfe-kHtRnhg2FEFE6Pg@mail.gmail.com> (sfid-20181109_071333_948093_8B533D40)
References: <20181018083547.23262-1-johannes@sipsolutions.net>
         <CANGSkXRMOK7dJwyRZOgBZbypvAPyV6DUEtE+2LGodtiN5=BqmQ@mail.gmail.com>
         <CANGSkXSox2BquGzhXzALtLxVe8nY67iOfe-kHtRnhg2FEFE6Pg@mail.gmail.com>
         (sfid-20181109_071333_948093_8B533D40)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-11-09 at 11:48 +0530, Siva Rebbagondla wrote:
> Hi,
> Gentle Remainder..!!!.
> Any update required for this patch?. If not, When can i expect this
> patch to be available in wireless-next?.

Sorry, I hadn't been merging things for a while due to the merge window.

I just put it into mac80211-next, so I guess the answer should be
"soon".

johannes

