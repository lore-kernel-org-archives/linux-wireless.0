Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52974 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753974AbdIFNDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 09:03:12 -0400
Message-ID: <1504702990.13457.19.camel@sipsolutions.net> (sfid-20170906_150332_587296_84FCF08E)
Subject: Re: hung task in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <sbrivio@redhat.com>,
        Matteo Croce <mcroce@redhat.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Sep 2017 15:03:10 +0200
In-Reply-To: <1504702115.13457.16.camel@sipsolutions.net> (sfid-20170906_144854_264235_DD6F357A)
References: <CAGnkfhwi9MmtLneeU23iWEGLj9cb1ODb3KzzOqTDvA6nNVsugg@mail.gmail.com>
         <20170906144019.1c98a636@elisabeth>
         (sfid-20170906_144115_600908_441D9559) <1504702115.13457.16.camel@sipsolutions.net>
         (sfid-20170906_144854_264235_DD6F357A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-09-06 at 14:48 +0200, Johannes Berg wrote:
> 
> I'm surprised nobody saw this before - though perhaps Sebastian's
> useless report is the same.

Oh, that's because this is only for the offloaded manager thing, and
that's only ath10k.

johannes
