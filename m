Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55066 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753896AbcLPJHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 04:07:39 -0500
Message-ID: <1481879214.27953.0.camel@sipsolutions.net> (sfid-20161216_100809_581197_6C4AC2CA)
Subject: Re: [PATCH mac80211-next] rfkill: hide unused goto label
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        =?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>,
        =?UTF-8?Q?Micha=C5=82_K=C4=99pie=C5=84?= <kernel@kempniu.pl>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Dec 2016 10:06:54 +0100
In-Reply-To: <20161216084425.1692828-1-arnd@arndb.de>
References: <20161216084425.1692828-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-12-16 at 09:44 +0100, Arnd Bergmann wrote:
> A cleanup introduced a harmless warning in some configurations:
> 
> net/rfkill/core.c: In function 'rfkill_init':
> net/rfkill/core.c:1350:1: warning: label 'error_input' defined but
> not used [-Wunused-label]
> 
> This adds another #ifdef around the label to match that around the
> caller.

Applied, thanks.

johannes
