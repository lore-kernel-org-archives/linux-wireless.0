Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.aperture-lab.de ([138.201.29.205]:51867 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754841AbcJQSPC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 14:15:02 -0400
Date: Mon, 17 Oct 2016 20:14:57 +0200
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: suggest nl80211 instead of wext driver
 in documentation
Message-ID: <20161017181457.GF6366@otheros> (sfid-20161017_201533_562828_F59D2936)
References: <20161016223933.9484-1-linus.luessing@c0d3.blue>
 <1476697144.19992.16.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1476697144.19992.16.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 17, 2016 at 11:39:04AM +0200, Johannes Berg wrote:
> On Mon, 2016-10-17 at 00:39 +0200, Linus Lüssing wrote:
> > For mac80211_hwsim interfaces, suggest to use wpa_supplicant with the
> > more modern, netlink based driver instead of wext.
> 
> Makes sense, applied.
> 
> > Actually, I wasn't even able to make a connection with the
> > configuration
> > files and information provided in
> > Documentation/networking/mac80211_hwsim/{README,hostapd.conf/wpa_supp
> > licant.conf}
> > 
> This less so, we even have a few test cases we run regularly, but I
> don't know. Maybe there's something special in those configuration
> files that we don't test for otherwise.

I investigated a little further and the problem is probably that
I'm running a minimal Linux kernel which was compiled without
CONFIG_CFG80211_WEXT :-).

Anyways, thanks for applying the patch!

Regards, Linus
