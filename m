Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56600 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751297AbcITOgu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 10:36:50 -0400
Message-ID: <1474382205.5664.196.camel@coelho.fi> (sfid-20160920_163654_312531_11FD9854)
From: Luca Coelho <luca@coelho.fi>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Tue, 20 Sep 2016 17:36:45 +0300
In-Reply-To: <972b9d18-218e-8b46-f56a-eab4c5981d0b@broadcom.com>
References: <20160916083321.5840-1-luca@coelho.fi>
         <20160916083321.5840-3-luca@coelho.fi>
         <fae482d0-4bcd-6b06-9846-298a3218ab26@broadcom.com>
         <B2CD83211F5FDD478D7EFFF030D107ED57286E64@hasmsx108.ger.corp.intel.com>
         <ab55211c-9e82-38cf-8f7f-effa4b12d72b@broadcom.com>
         <6E2DD73D17E17047917F6A81399A8ED3972503A6@hasmsx109.ger.corp.intel.com>
         <972b9d18-218e-8b46-f56a-eab4c5981d0b@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 2/9] mac80211: add boilerplate code for start / stop
 NAN
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Tue, 2016-09-20 at 14:29 +0200, Arend Van Spriel wrote:
> On 20-9-2016 13:45, Beker, Ayala wrote:
> > I don't think there is something in common to those interface types
> > that can fit such a function semantically, so I decided not to
> > change it.
> > Do you have any idea?
> 
> What is common is that these are both non-netdev interface types.

I tend to agree with you.  I also thought about an
ieee80211_has_netdev() function for this, but I didn't check whether
this was exactly what we need...

In any case, do you mind if we address this in a separate patch?

--
Cheers,
Luca.
