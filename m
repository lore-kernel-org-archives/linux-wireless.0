Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51537 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751522AbdC0T2i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Mar 2017 15:28:38 -0400
Date: Mon, 27 Mar 2017 21:28:35 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V4 1/2] firmware: add more flexible
 request_firmware_async function
Message-ID: <20170327192835.GM28800@wotan.suse.de> (sfid-20170327_213001_868053_5F077E23)
References: <20170221094754.15406-1-zajec5@gmail.com>
 <20170223183018.16704-1-zajec5@gmail.com>
 <f0451c04-cffe-ae1c-74de-38748da38272@gmail.com>
 <20170316140352.GA30080@kroah.com>
 <20170317172936.GG28800@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170317172936.GG28800@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 17, 2017 at 06:29:36PM +0100, Luis R. Rodriguez wrote:
> On Thu, Mar 16, 2017 at 11:03:52PM +0900, Greg KH wrote:
> > On Thu, Mar 16, 2017 at 02:55:09PM +0100, Rafał Miłecki wrote:
> > > Luis: would you ack this patch now I followed your guidance?
> > 
> > It's up to Luis now :)
> 
> I'm reviewing now!

This review has taken longer than expected given I was also reviewing
how to mesh in the new API I had been working on longer than this
patch series, and also address the long standing issues with the
UMH I have cringed over. Last week and this weekend I did most of
the hard work to feel happy with a resolution, and will now be folding
this functionality into my series.

So -- please have a bit of patience, and I will be spinning out a new
series which incorporates the functionality you have requested, just
meshed more in line with the other requirements we have had for a
while.

  Luis
