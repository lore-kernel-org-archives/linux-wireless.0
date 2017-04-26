Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44676 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1434115AbdDZI2U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 04:28:20 -0400
Message-ID: <1493195298.2464.11.camel@sipsolutions.net> (sfid-20170426_103038_274988_E2075505)
Subject: Re: [PATCH 0/9] cfg80211/mac80211 patches from our internal tree
 2017-04-26
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>
Date: Wed, 26 Apr 2017 10:28:18 +0200
In-Reply-To: <1493194297.14233.0.camel@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
         <1493194138.2464.10.camel@sipsolutions.net>
         <1493194297.14233.0.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-26 at 11:11 +0300, Luca Coelho wrote:
> On Wed, 2017-04-26 at 10:08 +0200, Johannes Berg wrote:
> > > Avraham Stern (3):
> > >   mac80211: Add support for BSS max idle period element
> > >   cfg80211: unify cfg80211_roamed() and cfg80211_roamed_bss()
> > >   cfg80211/nl80211: add authorized flag to roaming event
> > 
> > I'm going to let these get a bit more time on the list.
> > 
> > Arend, it'd be nice if you could take a look as well.
> 
> Yes, especially for the changes I made in the other drivers.  They
> look kind of ugly, IMHO.

I actually think they're a structural improvement since then we don't
have to touch everything for any kind of extension, and don't get so
many arguments ...

In fact, I'll probably apply that patch before I send the last pull
request, so we have it in during the merge window.

johannes
