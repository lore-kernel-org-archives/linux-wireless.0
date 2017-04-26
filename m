Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54598 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2993867AbdDZILk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 04:11:40 -0400
Message-ID: <1493194297.14233.0.camel@coelho.fi> (sfid-20170426_101300_682586_2ECDCF3A)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>
Date: Wed, 26 Apr 2017 11:11:37 +0300
In-Reply-To: <1493194138.2464.10.camel@sipsolutions.net>
References: <20170426075854.13546-1-luca@coelho.fi>
         <1493194138.2464.10.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 0/9] cfg80211/mac80211 patches from our internal tree
 2017-04-26
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-26 at 10:08 +0200, Johannes Berg wrote:
> > Avraham Stern (3):
> >   mac80211: Add support for BSS max idle period element
> >   cfg80211: unify cfg80211_roamed() and cfg80211_roamed_bss()
> >   cfg80211/nl80211: add authorized flag to roaming event
> 
> I'm going to let these get a bit more time on the list.
> 
> Arend, it'd be nice if you could take a look as well.

Yes, especially for the changes I made in the other drivers.  They look
kind of ugly, IMHO.

--
Luca.
