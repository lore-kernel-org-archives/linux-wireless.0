Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52673 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1031593AbdEXWkS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 18:40:18 -0400
Date: Thu, 25 May 2017 08:40:14 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: Re: WPA and WPA2
Message-ID: <20170524224014.GC2319@eros> (sfid-20170525_004022_592800_3A18AC91)
References: <20170524072750.GI8158@eros>
 <20170524073459.GJ8158@eros>
 <1495644240.12939.3.camel@redhat.com>
 <1495649200.20833.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495649200.20833.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 24, 2017 at 08:06:40PM +0200, Johannes Berg wrote:
> Just a small correction:
> 
> On Wed, 2017-05-24 at 11:44 -0500, Dan Williams wrote:
> > 
> > For RSN, they are 1 = PMK, 2 = GMK, 3 = GMK2, 4 seems unused.
> 
> PTK and GTK, and in theory you could have more than two GTKs but that's
> not usually done.

Excuse my ignorance but why do you say PTK and GTK here? Who generates
the transient keys, hardware, firmware or software? Is this device
specific or is there a *normal* way?

>From the nomenclature in the WEXT driver I thought the driver supplied the
master keys to the firmware and transient keys were generated at the
firmware layer or lower.

thanks,
Tobin.
