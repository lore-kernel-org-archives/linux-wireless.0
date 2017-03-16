Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41756 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751146AbdCPJzW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 05:55:22 -0400
Message-ID: <1489658072.2370.1.camel@sipsolutions.net> (sfid-20170316_105532_101364_E6064328)
Subject: Re: [PATCH] mac80211: Use setup_timer instead of init_timer
From: Johannes Berg <johannes@sipsolutions.net>
To: ondrej.lysonek@seznam.cz
Cc: Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 16 Mar 2017 10:54:32 +0100
In-Reply-To: <20170309093436.25227-1-ondrej.lysonek@seznam.cz>
References: <1488803104.5761.6.camel@sipsolutions.net>
         <20170309093436.25227-1-ondrej.lysonek@seznam.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-03-09 at 10:34 +0100, ondrej.lysonek@seznam.cz wrote:
> From: Ondřej Lysoněk <ondrej.lysonek@seznam.cz>
> 
> Use setup_timer() and setup_deferrable_timer() to set the data and
> function timer fields. It makes the code cleaner and will allow for
> easier change of the timer struct internals.
> 
Applied, thanks.

johannes
