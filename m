Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34748 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbdBUJmo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 04:42:44 -0500
Message-ID: <1487670161.2215.2.camel@sipsolutions.net> (sfid-20170221_104247_463602_711CFEA4)
Subject: Re: wpa psk offloading
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 21 Feb 2017 10:42:41 +0100
In-Reply-To: <11aeb0b3-5c44-32d5-c73a-c809f3d53c9f@broadcom.com> (sfid-20170221_102028_168548_D26D0351)
References: <11aeb0b3-5c44-32d5-c73a-c809f3d53c9f@broadcom.com>
         (sfid-20170221_102028_168548_D26D0351)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-21 at 10:20 +0100, Arend Van Spriel wrote:
> Hi Johannes,
> 
> Internally I am asked to look at "pmk plumbing" patches allowing
> firmware to deal with 4-way handshake. Now I noticed this topic being
> discussed during last wireless workshop in Santa Fe [1].
> 
> I do not recall any follow-up after that. At least no concrete
> patches, right? Also in wpa_supplicant there is already a solution
> using QCA vendor command. Should we aim to adopt just that or are
> there issues/requirements not covered by that.

I don't think we should adopt a QCA vendor command as the official
solution :)

We do have a patch internally, I'll send it out - we just haven't
managed to release the driver for it yet.

johannes
