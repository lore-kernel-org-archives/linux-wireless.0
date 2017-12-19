Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0079.outbound.protection.outlook.com ([104.47.33.79]:64724
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753159AbdLSK3q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 05:29:46 -0500
Date: Tue, 19 Dec 2017 13:29:33 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 10/10] qtnfmac: support MAC address based access control
Message-ID: <20171219102932.xv7bxasvlvguy7jb@bars> (sfid-20171219_112953_231784_2278C787)
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
 <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
 <871skalepz.fsf@purkki.adurom.net>
 <20171205160010.cytra3bqbttwz5db@bars>
 <878te0kud2.fsf@kamboji.qca.qualcomm.com>
 <20171218161811.3f3sjhlxdfmsnljx@bars>
 <1513676321.26145.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513676321.26145.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

> > Meanwhile now it is not yet clear to me what should be done for driver which
> > supports MAC-based ACL, but not full-fledged AP SME.
> 
> Are you sure that such a device can even exist? It'd have to drop the
> auth frames, so they can't be handled by the host? Is there much point
> in that?

I guess it should be possible to do some kind of source address filtering
in hardware. But it looks like your question is whether it makes sense
or not. Probably not, I have no idea.

By the way, what do you think about making MAC-based ACL capability the
first bit in enum nl80211_ap_sme_features ?

Regards,
Sergey
