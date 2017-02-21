Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35852 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752080AbdBULqZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 06:46:25 -0500
Message-ID: <1487677574.2215.4.camel@sipsolutions.net> (sfid-20170221_124646_341452_4802AC0E)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Date: Tue, 21 Feb 2017 12:46:14 +0100
In-Reply-To: <a021dbf9-854d-0339-b87d-b27b746ccd1b@broadcom.com> (sfid-20170221_124525_355347_D9C99AD5)
References: <20170221100957.30965-1-johannes@sipsolutions.net>
         <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
         <1487673603.2215.3.camel@sipsolutions.net>
         <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
         <a021dbf9-854d-0339-b87d-b27b746ccd1b@broadcom.com>
         (sfid-20170221_124525_355347_D9C99AD5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > Would this work for you? We should have wpa_supplicant support
> > > too, but need to ask Andrei to look at that.
> 
> Forgot to reply to this. Yes, this will work. Can come up with
> wpa_supp changes.

No, we have them. Just need to see where they are :)

johannes
