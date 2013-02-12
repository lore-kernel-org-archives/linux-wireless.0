Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab3BLN6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 08:58:07 -0500
Message-ID: <1360677480.29913.0.camel@jlt4.sipsolutions.net> (sfid-20130212_145810_498410_382A2BA2)
Subject: Re: [RFC 1/2] cfg80211: advertise extended capabilities to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 12 Feb 2013 14:58:00 +0100
In-Reply-To: <87r4klab40.fsf@purkki.adurom.net>
References: <1360593979-27972-1-git-send-email-johannes@sipsolutions.net>
	 <87r4klab40.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 15:57 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > In many cases, userspace may need to know which of the
> > extended capabilities are implemented in the driver or
> > device, to include them e.g. in beacons, association
> > request/response or other frames. Add a new nl80211
> > attribute that holds the extended capabilities bitmap
> > supported by the driver/device for this.
> 
> [...]
> 
> > + * @extended_capabilities: extended capabilities supported by the driver,
> > + *	additional capabilities might be supported by userspace
> > + * @extended_capabilities_len: length of the extended capabilities
> 
> FWIW, when I first looked at the patch I wasn't sure if you were
> referring to 802.11 or nl80211 capabilities. I assumed the former. But
> clarifying that in the documentation would be good.

Makes sense, will do that.

johannes

