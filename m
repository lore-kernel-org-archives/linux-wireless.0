Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45926 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932864AbdCaMmX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 08:42:23 -0400
Message-ID: <1490964139.6288.15.camel@sipsolutions.net> (sfid-20170331_144225_611639_989AFF1C)
Subject: Re: [RFC v2 2/2] cfg80211: support 4-way handshake offloading for
 802.1X
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>
Date: Fri, 31 Mar 2017 14:42:19 +0200
In-Reply-To: <91ed1c3e-f28a-b591-344d-e59765a9b944@broadcom.com> (sfid-20170331_143947_688137_97C2CDA0)
References: <20170221123758.5339-1-johannes@sipsolutions.net>
         <20170221123758.5339-2-johannes@sipsolutions.net>
         <5274c4b4-9bce-208c-e3f2-640d54b81a30@broadcom.com>
         <1490961001.6288.8.camel@sipsolutions.net>
         <91ed1c3e-f28a-b591-344d-e59765a9b944@broadcom.com>
         (sfid-20170331_143947_688137_97C2CDA0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-31 at 14:39 +0200, Arend Van Spriel wrote:
> 
> Ok. Just wondering. I am ok with the proposal with the addition of
> authorized flag in connect event. So do you expect these to come as
> non-rfc patches any time soon?
> 

Hmm. I need to find time to look at it, but I'll be travelling next
week for netconf/netdev.

If you wanted to pick up anything here I won't stop you :)

johannes
