Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52714 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933837AbdEVQeF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 12:34:05 -0400
Message-ID: <1495470842.26008.4.camel@sipsolutions.net> (sfid-20170522_183705_491099_D4E926EB)
Subject: Re: [PATCH] cfg80211: Be able to set bss expire time at config
 stage.
From: Johannes Berg <johannes@sipsolutions.net>
To: Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Shmidt <dimitrysh@google.com>,
        helmut.schaa@googlemail.com
Date: Mon, 22 May 2017 18:34:02 +0200
In-Reply-To: <1495469954.26008.1.camel@sipsolutions.net> (sfid-20170522_182014_038071_64240E1B)
References: <20170522160946.2057-1-enric.balletbo@collabora.com>
         <1495469954.26008.1.camel@sipsolutions.net>
         (sfid-20170522_182014_038071_64240E1B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-05-22 at 18:19 +0200, Johannes Berg wrote:
> 
> I'm not really all that convinced that we really need this -
> userspace should just be using the flush thing more often, and then
> it doesn't really matter.
> 
> However, maybe that doesn't really matter all that much.

Actually, I changed my mind based on the discussion with Dan. This
makes no sense, and since you've obviously never even tested this
patch, you probably haven't thought about alternatives either.

johannes
