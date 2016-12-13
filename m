Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50186 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933592AbcLMPQY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 10:16:24 -0500
Message-ID: <1481642180.20412.1.camel@sipsolutions.net> (sfid-20161213_161659_748700_D9D1BAB5)
Subject: Re: [PATCH v2 1/2] net: rfkill: Cleanup error handling in
 rfkill_init()
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82_K=C4=99pie=C5=84?= <kernel@kempniu.pl>,
        "David S . Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 13 Dec 2016 16:16:20 +0100
In-Reply-To: <20161208073052.12988-1-kernel@kempniu.pl> (sfid-20161208_083101_604229_2D2C8421)
References: <20161208073052.12988-1-kernel@kempniu.pl>
         (sfid-20161208_083101_604229_2D2C8421)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-12-08 at 08:30 +0100, Michał Kępień wrote:
> Use a separate label per error condition in rfkill_init() to make it
> a bit cleaner and easier to extend.

applied.

johannes
