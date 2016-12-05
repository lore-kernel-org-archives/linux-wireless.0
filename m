Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42858 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbcLENyV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 08:54:21 -0500
Message-ID: <1480946052.31788.5.camel@sipsolutions.net> (sfid-20161205_145424_735587_E491BD32)
Subject: Re: [PATCH 2/2] net: rfkill: Add rfkill-any LED trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82_K=C4=99pie=C5=84?= <kernel@kempniu.pl>,
        kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Dec 2016 14:54:12 +0100
In-Reply-To: <20161201200804.GA3872@kmp-mobile.hq.kempniu.pl> (sfid-20161201_210813_179873_52F3B24D)
References: <20161130120317.11851-2-kernel@kempniu.pl>
         <201612020131.aDbI7Mq9%fengguang.wu@intel.com>
         <20161201200804.GA3872@kmp-mobile.hq.kempniu.pl>
         (sfid-20161201_210813_179873_52F3B24D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Thanks, these are obviously all valid concerns.  Sorry for being
> sloppy
> with the ifdefs.  If I get positive feedback on the proposed feature
> itself, all these issues (and the warning pointed out in the other
> message) will be resolved in v2.

Looks fine, please do that.

johannes
