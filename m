Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:14625 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752881AbcISIHh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 04:07:37 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH v2 4/9] cfg80211: allow the user space to change current
 NAN configuration
Date: Mon, 19 Sep 2016 08:07:32 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED57289522@hasmsx108.ger.corp.intel.com> (sfid-20160919_100743_955633_4FDFFF6B)
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-5-luca@coelho.fi>
 <6a81754d-ff9f-9f79-d7d0-9d5431f681ac@broadcom.com>
In-Reply-To: <6a81754d-ff9f-9f79-d7d0-9d5431f681ac@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Arend Van Spriel [mailto:arend.vanspriel@broadcom.com]
> Sent: Sunday, September 18, 2016 22:43
> To: Luca Coelho <luca@coelho.fi>; johannes@sipsolutions.net
> Cc: linux-wireless@vger.kernel.org; Beker, Ayala <ayala.beker@intel.com>;
> Otcheretianski, Andrei <andrei.otcheretianski@intel.com>; Grumbach,
> Emmanuel <emmanuel.grumbach@intel.com>; Coelho, Luciano
> <luciano.coelho@intel.com>
> Subject: Re: [PATCH v2 4/9] cfg80211: allow the user space to change current
> NAN configuration
> 
> On 16-9-2016 10:33, Luca Coelho wrote:
> > From: Ayala Beker <ayala.beker@intel.com>
> >
> > Some NAN configuration paramaters may change during the operation of
> > the NaN device. For example, a user may want to update master
> > preference
> 
> typo: NAN iso NaN.

Thanks

> 
> Regards,
> Arend
