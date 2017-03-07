Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57716 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755026AbdCGJS1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 04:18:27 -0500
Message-ID: <1488876157.2366.0.camel@sipsolutions.net> (sfid-20170307_101834_926972_0CB50E59)
Subject: Re: [PATCH] mac80211: ignore VHT membership selector when parsing
 rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 07 Mar 2017 09:42:37 +0100
In-Reply-To: <220e1799-9fba-c113-805d-3589421cdecd@broadcom.com> (sfid-20170307_093931_723384_B75DC7F7)
References: <20170306220113.4666-1-johannes@sipsolutions.net>
         <220e1799-9fba-c113-805d-3589421cdecd@broadcom.com>
         (sfid-20170307_093931_723384_B75DC7F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >  
> >  		/*
> > -		 * BSS_MEMBERSHIP_SELECTOR_HT_PHY is defined in
> > 802.11n-2009
> > -		 * 7.3.2.2 as a magic value instead of a rate.
> > Hence, skip it.
> > +		 * Skip HT and VHT BSS membership selectors since
> > they're not
> > +		 * rates.
> >  		 *
> >  		 * Note: Even through the membership selector and
> > the basic
> 
> typo: through -> though.

That's just existing context ;-)

Will fix here.

johannes
