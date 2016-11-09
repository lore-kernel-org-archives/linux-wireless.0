Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:56709 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932705AbcKIPGu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 10:06:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Jouni Malinen <j@w1.fi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: fix bogus maybe-uninitialized warning
Date: Wed, 09 Nov 2016 16:06:32 +0100
Message-ID: <2654653.cBclyC49py@wuerfel> (sfid-20161109_160714_504745_0266CA58)
In-Reply-To: <1478679046.4345.1.camel@sipsolutions.net>
References: <20161024153918.2810634-1-arnd@arndb.de> <87mvh9qwhi.fsf@purkki.adurom.net> <1478679046.4345.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, November 9, 2016 9:10:46 AM CET Johannes Berg wrote:
> 
> > Ideally we prefer that drivers/net/wireless and net/wireless changes
> > are
> > split into different patches as they get applied to different trees.

Ok, good to know. I had split out the drivers/staging changes, but
wasn't sure about the granularity you'd want here.

> > Johannes, is it ok if I take this change through my tree this time?

> Sure, please do, thanks.
> 
> (I don't particularly care about the lib80211 stuff anyway)

Thanks!

	Arnd
