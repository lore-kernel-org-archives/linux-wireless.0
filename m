Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60386 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdJCHhO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2017 03:37:14 -0400
Message-ID: <1507016232.2545.0.camel@sipsolutions.net> (sfid-20171003_093718_039956_770F7E55)
Subject: Re: [PATCH] cfg80211/nl80211: add a port authorized event
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>, luca@coelho.fi
Date: Tue, 03 Oct 2017 09:37:12 +0200
In-Reply-To: <0c8ca5c1-eabd-2cfa-ec5c-70dc0dfac61b@broadcom.com> (sfid-20171002_230920_600997_60930A72)
References: <20170929122149.29710-1-johannes@sipsolutions.net>
         <0c8ca5c1-eabd-2cfa-ec5c-70dc0dfac61b@broadcom.com>
         (sfid-20171002_230920_600997_60930A72)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-02 at 23:09 +0200, Arend van Spriel wrote:
> On 29-09-17 14:21, Johannes Berg wrote:
> > From: Avraham Stern <avraham.stern@intel.com>
> > 
> > Add an event that indicates that a connection is authorized
> > (i.e. the 4 way handshake was performed by the driver). This event
> > should be sent by the driver after sending a connect/roamed event.
> 
> So is this event required for drivers supporting 4-way handshake 
> offload. If so, the "should" above might need to be "shall" and I
> have some changes to do in brcmfmac ;-)

I'm not sure it's *required*? I guess it would be for 802.1X on the
host/4-way-HS in the device, but not necessarily for the other cases?

johannes
