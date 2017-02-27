Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36684 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751431AbdB0NzR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 08:55:17 -0500
Message-ID: <1488201362.28431.0.camel@sipsolutions.net> (sfid-20170227_145610_425152_06EF7288)
Subject: Re: [PATCH] mac80211: Print text for disassociation reason
From: Johannes Berg <johannes@sipsolutions.net>
To: Arkadiusz =?UTF-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Arkadiusz =?UTF-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Date: Mon, 27 Feb 2017 14:16:02 +0100
In-Reply-To: <20170215132127.17177-1-arekm@maven.pl> (sfid-20170215_142204_744692_FF140286)
References: <20170215132127.17177-1-arekm@maven.pl>
         (sfid-20170215_142204_744692_FF140286)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-15 at 14:21 +0100, Arkadiusz Miśkiewicz wrote:
> When disassociation happens only numeric reason is printed
> in ieee80211_rx_mgmt_disassoc(). Add text variant, too.

Applied, thanks.

johannes
