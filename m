Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41182 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933991AbdLSK7s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 05:59:48 -0500
Message-ID: <1513681186.26145.14.camel@sipsolutions.net> (sfid-20171219_115952_548037_CD0BFA80)
Subject: Re: [PATCH 10/10] qtnfmac: support MAC address based access control
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Tue, 19 Dec 2017 11:59:46 +0100
In-Reply-To: <20171219104233.wcyemlr3gp4rq5ae@bars>
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
         <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
         <871skalepz.fsf@purkki.adurom.net> <20171205160010.cytra3bqbttwz5db@bars>
         <878te0kud2.fsf@kamboji.qca.qualcomm.com>
         <20171218161811.3f3sjhlxdfmsnljx@bars>
         <1513676321.26145.1.camel@sipsolutions.net>
         <20171219102932.xv7bxasvlvguy7jb@bars>
         <1513679705.26145.13.camel@sipsolutions.net>
         <20171219104233.wcyemlr3gp4rq5ae@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-12-19 at 13:42 +0300, Sergey Matyukevich wrote:

> Not yet. At the moment enum nl80211_ap_sme_features in uapi/linux/nl80211.h
> is commented out. For MAC-based ACL the following things are being checked
> on wiphy registration: complete flag WIPHY_FLAG_HAVE_AP_SME, non-zero
> max_acl_mac_addrs, and set_mac_acl cfg80211 callback.

I guess that's enough then? Userspace can check max_acl_mac_addrs as
well, so it can just use that?

johannes
