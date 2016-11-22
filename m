Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51266 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751328AbcKVHae (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 02:30:34 -0500
Message-ID: <1479799830.4391.6.camel@sipsolutions.net> (sfid-20161122_083041_116732_99037596)
Subject: Re: [PATCH] mac80211: Remove unused 'struct rate_control_ref'
 variable
From: Johannes Berg <johannes@sipsolutions.net>
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Maxim Altshul <maxim.altshul@ti.com>
Date: Tue, 22 Nov 2016 08:30:30 +0100
In-Reply-To: <20161122065416.GA3565@google.com> (sfid-20161122_075424_196465_55445AD4)
References: <20161122065416.GA3565@google.com>
         (sfid-20161122_075424_196465_55445AD4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-11-21 at 22:54 -0800, Kirtika Ruchandani wrote:
> Commit 3b17fbf87d5d introduced sta_get_expected_throughput()
> leaving variable 'struct rate_control_ref* ref' set but unused.
> Compiling with W=1 gives the following warning, fix it.
> 
> net/mac80211/sta_info.c: In function ‘sta_set_sinfo’:
> net/mac80211/sta_info.c:2052:27: warning: variable ‘ref’ set but not
> used [-Wunused-but-set-variable]

Applied all three of these, thanks Kirtika.

johannes
