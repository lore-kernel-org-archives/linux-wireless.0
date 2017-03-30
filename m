Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58302 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933236AbdC3IGK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 04:06:10 -0400
Message-ID: <1490861167.32041.2.camel@sipsolutions.net> (sfid-20170330_100615_801684_693E1479)
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Dennis New <dennisn@dennisn.mooo.com>
Date: Thu, 30 Mar 2017 10:06:07 +0200
In-Reply-To: <483e7122-0a36-b76f-88ba-5b59d4a84a9f@broadcom.com> (sfid-20170329_205825_013321_2CDD62BA)
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
         <1490772890.18052.8.camel@sipsolutions.net>
         <20170329062808.032e71a5327f3405f82df4b2@dennisn.mooo.com>
         <1490788146.7948.19.camel@sipsolutions.net>
         <483e7122-0a36-b76f-88ba-5b59d4a84a9f@broadcom.com>
         (sfid-20170329_205825_013321_2CDD62BA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-03-29 at 20:58 +0200, Arend Van Spriel wrote:
> 
> > >       * 2437 MHz [6] 
> > >         Maximum TX power: 20.0 dBm
> > >         Channel widths:
> > 
> > That's quite odd, why isn't it listing any possible channel
> > widths?!
> 
> Is iw not handling 20MHZ_NOHT definition?

But iw is printing "20MHz" when NL80211_FREQUENCY_ATTR_NO_20MHZ isn't
set.

johannes
