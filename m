Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35753 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942086AbcJSPoK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:44:10 -0400
Message-ID: <1476862713.5927.0.camel@sipsolutions.net> (sfid-20161019_174414_496683_5937EEDF)
Subject: Re: [PATCH net-next 2/6] net: use core MTU range checking in
 wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Simon Kelley <simon@thekelleys.org.uk>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date: Wed, 19 Oct 2016 09:38:33 +0200
In-Reply-To: <20161019023333.15760-3-jarod@redhat.com> (sfid-20161019_043512_692157_D515CD3E)
References: <20161019023333.15760-1-jarod@redhat.com>
         <20161019023333.15760-3-jarod@redhat.com>
         (sfid-20161019_043512_692157_D515CD3E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-18 at 22:33 -0400, Jarod Wilson wrote:
> - set max_mtu in wil6210 driver
> - set max_mtu in atmel driver
> - set min/max_mtu in cisco airo driver, remove airo_change_mtu
> - set min/max_mtu in ipw2100/ipw2200 drivers, remove
> libipw_change_mtu
> - set min/max_mtu in p80211netdev, remove wlan_change_mtu

I guess we should do the same in net/mac80211/iface.c?

johannes
