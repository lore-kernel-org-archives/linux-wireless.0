Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44270 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758061Ab3HNPMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 11:12:00 -0400
From: "Bondar, Alexander" <alexander.bondar@intel.com>
To: Arik Nemtsov <arik@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 28/30] iwlwifi: mvm: Change beacon abort escape time
 value
Date: Wed, 14 Aug 2013 15:11:53 +0000
Message-ID: <60035555E48905429C8B264861CA6BB401913ED7@HASMSX103.ger.corp.intel.com> (sfid-20130814_171204_788224_E41F4E94)
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
 <1374827327-3464-29-git-send-email-johannes@sipsolutions.net>
 <CA+XVXfeoHkOwrj76MwSC9ad5igffng8QueT6cKu9ytsLu=C+Cw@mail.gmail.com>
In-Reply-To: <CA+XVXfeoHkOwrj76MwSC9ad5igffng8QueT6cKu9ytsLu=C+Cw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, it's a bug. Intention was 9.
Thanks.

> -----Original Message-----
> From: anamtsov@gmail.com [mailto:anamtsov@gmail.com] On Behalf Of
> Arik Nemtsov
> Sent: Monday, August 12, 2013 3:21 PM
> To: Johannes Berg
> Cc: linux-wireless@vger.kernel.org; Bondar, Alexander
> Subject: Re: [PATCH 28/30] iwlwifi: mvm: Change beacon abort escape time
> value
> 
> On Fri, Jul 26, 2013 at 11:28 AM, Johannes Berg <johannes@sipsolutions.net>
> wrote:
> > From: Alexander Bondar <alexander.bondar@intel.com>
> >
> > Set beacon abort escape timer values - 6 beacons in D0 state,
> > 9 beacons in D3 and D0i3.
> >
> > Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
> > Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 3 ++-
> >  drivers/net/wireless/iwlwifi/mvm/power.c        | 3 +++
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
> > b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
> > index 149347d..060e630 100644
> > --- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
> > +++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
> > @@ -285,7 +285,8 @@ struct iwl_beacon_filter_cmd {  #define
> > IWL_BF_ESCAPE_TIMER_MAX 1024  #define IWL_BF_ESCAPE_TIMER_MIN
> 0
> >
> > -#define IWL_BA_ESCAPE_TIMER_DEFAULT 3
> > +#define IWL_BA_ESCAPE_TIMER_DEFAULT 6 #define
> IWL_BA_ESCAPE_TIMER_D3
> > +6
> 
> Did you mean 9 here?
> (Sorry for the late review)
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

