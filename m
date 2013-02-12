Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54745 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3BLN5U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 08:57:20 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] cfg80211: advertise extended capabilities to userspace
References: <1360593979-27972-1-git-send-email-johannes@sipsolutions.net>
Date: Tue, 12 Feb 2013 15:57:19 +0200
In-Reply-To: <1360593979-27972-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Mon, 11 Feb 2013 15:46:18 +0100")
Message-ID: <87r4klab40.fsf@purkki.adurom.net> (sfid-20130212_145724_619068_4270DE2D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> In many cases, userspace may need to know which of the
> extended capabilities are implemented in the driver or
> device, to include them e.g. in beacons, association
> request/response or other frames. Add a new nl80211
> attribute that holds the extended capabilities bitmap
> supported by the driver/device for this.

[...]

> + * @extended_capabilities: extended capabilities supported by the driver,
> + *	additional capabilities might be supported by userspace
> + * @extended_capabilities_len: length of the extended capabilities

FWIW, when I first looked at the patch I wasn't sure if you were
referring to 802.11 or nl80211 capabilities. I assumed the former. But
clarifying that in the documentation would be good.

-- 
Kalle Valo
