Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34964 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941555AbcJSO2K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:28:10 -0400
Message-ID: <1476887287.10092.13.camel@sipsolutions.net> (sfid-20161019_174857_174099_33D9F5A6)
Subject: Re: [PATCH net-next 2/6] net: use core MTU range checking in
 wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Simon Kelley <simon@thekelleys.org.uk>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date: Wed, 19 Oct 2016 16:28:07 +0200
In-Reply-To: <20161019142706.GE18569@redhat.com> (sfid-20161019_162711_480451_2E690F9F)
References: <20161019023333.15760-1-jarod@redhat.com>
         <20161019023333.15760-3-jarod@redhat.com>
         <1476862713.5927.0.camel@sipsolutions.net>
         <20161019142706.GE18569@redhat.com> (sfid-20161019_162711_480451_2E690F9F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I guess we should do the same in net/mac80211/iface.c?
> 
> Yeah. I thought I'd located all places this needed to happen, but
> obviously not. I'll get this added and do another sweep for others I
> might have missed.

No worries. I can also do it if you prefer, just wanted to ask :)

johannes
