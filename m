Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47447 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750929AbcHZIOy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 04:14:54 -0400
Message-ID: <1472199291.390.23.camel@sipsolutions.net> (sfid-20160826_101458_411417_7C2B47A2)
Subject: Re: [PATCH] cfg80211: Add support for user configurable beacon data
 rate
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        "Kondabattini, Ganesh" <ganeshk@qti.qualcomm.com>,
        "Kalikot Veetil, Mahesh Kumar" <mkalikot@qca.qualcomm.com>,
        "Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>,
        "Kumar, Deepak (QCA)" <djindal@qti.qualcomm.com>
Date: Fri, 26 Aug 2016 10:14:51 +0200
In-Reply-To: <17fc8f16b6184c2ba09146faefd2bc8c@aphydexm01f.ap.qualcomm.com>
References: <1470371701-13074-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1470387784.2977.30.camel@sipsolutions.net>
         <92b06d4df5984e6ea91081126e096a96@aphydexm01f.ap.qualcomm.com>
         <1470513454.3374.1.camel@sipsolutions.net>
         <17fc8f16b6184c2ba09146faefd2bc8c@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-08-24 at 12:30 +0000, Undekari, Sunil Dutt wrote:

> > It also doesn't check that you specified exactly one rate, but it's
> > not clear how else this would work?
> I can think of the following options here . 
> 1. Consider these rates as only the preference ( in order ) to the
> host driver , but the User space would have no way of knowing what
> the driver has selected.
> 2. Limit this beacon rate to only one . cfg80211 to verify that there
> is exactly one rate to be specified. 
> 
> Is option 2 a viable option ?
> 
Yeah, I think option 1 doesn't make much sense.

johannes
