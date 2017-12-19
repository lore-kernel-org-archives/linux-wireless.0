Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39220 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932699AbdLSKfH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 05:35:07 -0500
Message-ID: <1513679705.26145.13.camel@sipsolutions.net> (sfid-20171219_113513_345982_3D14EE18)
Subject: Re: [PATCH 10/10] qtnfmac: support MAC address based access control
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Tue, 19 Dec 2017 11:35:05 +0100
In-Reply-To: <20171219102932.xv7bxasvlvguy7jb@bars>
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
         <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
         <871skalepz.fsf@purkki.adurom.net> <20171205160010.cytra3bqbttwz5db@bars>
         <878te0kud2.fsf@kamboji.qca.qualcomm.com>
         <20171218161811.3f3sjhlxdfmsnljx@bars>
         <1513676321.26145.1.camel@sipsolutions.net>
         <20171219102932.xv7bxasvlvguy7jb@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I guess it should be possible to do some kind of source address filtering
> in hardware. But it looks like your question is whether it makes sense
> or not. Probably not, I have no idea.

Either way, I see no reason to support it if nobody has a driver for it
:)

> By the way, what do you think about making MAC-based ACL capability the
> first bit in enum nl80211_ap_sme_features ?

No issues with that; I thought we already had some ACL feature bit
though?

johannes
