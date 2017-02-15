Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57164 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751305AbdBOJRA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:17:00 -0500
Message-ID: <1487150216.4026.18.camel@sipsolutions.net> (sfid-20170215_101711_469850_0B56C953)
Subject: Re: [RFC v2 3/7] ieee80211: add new VHT capability fields/parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: j@w1.fi, greearb@candelatech.com
Date: Wed, 15 Feb 2017 10:16:56 +0100
In-Reply-To: <281180d5-2a7e-00b5-f12b-13bf568812da@broadcom.com> (sfid-20170215_100812_870620_DD85F105)
References: <20170214132208.8715-1-johannes@sipsolutions.net>
         <20170214132208.8715-4-johannes@sipsolutions.net>
         <281180d5-2a7e-00b5-f12b-13bf568812da@broadcom.com>
         (sfid-20170215_100812_870620_DD85F105)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-15 at 10:08 +0100, Arend Van Spriel wrote:
> [snip]
> 
> Looks good to me.

Thanks for checking :)

> > +	/* not covered or invalid combination received */
> 
> Do you want to inform about the invalid/reserved combination.

I'm not really sure what to do - we don't really want to print a
message on something that might have been received from the peer, I
think? Though I suppose we should return 0 for the invalid
combinations, indicating that they're not supported.

johannes
