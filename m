Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48671 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757721AbcH3GHh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 02:07:37 -0400
Message-ID: <1472537253.4249.6.camel@sipsolutions.net> (sfid-20160830_080800_275669_F21D136F)
Subject: Re: [PATCH] cfg80211: Add stub for cfg80211_get_station()
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        linux-wireless@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Antonio Quartulli <a@unstable.cc>,
        b.a.t.m.a.n@lists.open-mesh.org
Date: Tue, 30 Aug 2016 08:07:33 +0200
In-Reply-To: <20160819200248.8202-1-linus.luessing@c0d3.blue> (sfid-20160819_220304_170640_809CF938)
References: <20160819200248.8202-1-linus.luessing@c0d3.blue>
         (sfid-20160819_220304_170640_809CF938)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-19 at 22:02 +0200, Linus Lüssing wrote:
> This allows modules using this function (currently: batman-adv) to
> compile even if cfg80211 is not built at all, thus relaxing
> dependencies.
> 
Err, excuse the earlier empty email - editing mixup.

I've applied this and will send it to 4.8 so you can take advantage of
it sooner (to adjust the Kconfig dependencies, presumably).

johannes
