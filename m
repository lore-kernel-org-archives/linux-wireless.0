Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35286 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbcIUIAW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 04:00:22 -0400
Received: by mail-pf0-f171.google.com with SMTP id z123so16674520pfz.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2016 01:00:22 -0700 (PDT)
Subject: Re: [PATCH v2 2/9] mac80211: add boilerplate code for start / stop
 NAN
To: Luca Coelho <luca@coelho.fi>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-3-luca@coelho.fi>
 <fae482d0-4bcd-6b06-9846-298a3218ab26@broadcom.com>
 <B2CD83211F5FDD478D7EFFF030D107ED57286E64@hasmsx108.ger.corp.intel.com>
 <ab55211c-9e82-38cf-8f7f-effa4b12d72b@broadcom.com>
 <6E2DD73D17E17047917F6A81399A8ED3972503A6@hasmsx109.ger.corp.intel.com>
 <972b9d18-218e-8b46-f56a-eab4c5981d0b@broadcom.com>
 <1474382205.5664.196.camel@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a392b8e4-31c6-6acf-d7af-9ce33fc2a739@broadcom.com> (sfid-20160921_100026_632781_5A0ADD19)
Date: Wed, 21 Sep 2016 10:00:16 +0200
MIME-Version: 1.0
In-Reply-To: <1474382205.5664.196.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 20-9-2016 16:36, Luca Coelho wrote:
> Hi Arend,
> 
> On Tue, 2016-09-20 at 14:29 +0200, Arend Van Spriel wrote:
>> On 20-9-2016 13:45, Beker, Ayala wrote:
>>> I don't think there is something in common to those interface types
>>> that can fit such a function semantically, so I decided not to
>>> change it.
>>> Do you have any idea?
>>
>> What is common is that these are both non-netdev interface types.
> 
> I tend to agree with you.  I also thought about an
> ieee80211_has_netdev() function for this, but I didn't check whether
> this was exactly what we need...

Maybe it does not fit all instances, but quite a few checks are there to
skip netdev related stuff.

> In any case, do you mind if we address this in a separate patch?

Fine by me.

Regards,
Arend

> --
> Cheers,
> Luca.
> 
