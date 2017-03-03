Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39128 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751332AbdCCMWM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 07:22:12 -0500
Message-ID: <1488543681.25750.3.camel@sipsolutions.net> (sfid-20170303_132217_281671_C5804ABA)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Avraham Stern <avraham.stern@intel.com>
Date: Fri, 03 Mar 2017 13:21:21 +0100
In-Reply-To: <96cd71c3-c279-b298-3876-68bac7297dc4@broadcom.com> (sfid-20170228_120643_426485_6E72CF0B)
References: <20170221100957.30965-1-johannes@sipsolutions.net>
         <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
         <1487673603.2215.3.camel@sipsolutions.net>
         <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
         <a021dbf9-854d-0339-b87d-b27b746ccd1b@broadcom.com>
         <1487677574.2215.4.camel@sipsolutions.net>
         <96cd71c3-c279-b298-3876-68bac7297dc4@broadcom.com>
         (sfid-20170228_120643_426485_6E72CF0B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-28 at 12:06 +0100, Arend Van Spriel wrote:
> On 21-2-2017 12:46, Johannes Berg wrote:
> > 
> > > > > Would this work for you? We should have wpa_supplicant
> > > > > support
> > > > > too, but need to ask Andrei to look at that.
> > > 
> > > Forgot to reply to this. Yes, this will work. Can come up with
> > > wpa_supp changes.
> > 
> > No, we have them. Just need to see where they are :)
> 
> Found anything ? :-p

Sorry, got too busy with other stuff.

+Andrei, can you send out the patches from Avi in wpa_s for doing the
4-way-HS offload (as an RFC)?

Arend, wait a bit - he's travelling now I think.

Thanks,
johannes
