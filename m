Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2044 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab3B0Mah (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 07:30:37 -0500
Message-ID: <512DFC54.60602@broadcom.com> (sfid-20130227_133040_714989_9A702E8E)
Date: Wed, 27 Feb 2013 13:30:12 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] cfg80211: advertise extended capabilities to
 userspace
References: <1360677682-3694-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1360677682-3694-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/13 15:01, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In many cases, userspace may need to know which of the
> 802.11 extended capabilities ("Extended Capabilities
> element") are implemented in the driver or device, to
> include them e.g. in beacons, assoc request/response
> or other frames. Add a new nl80211 attribute to hold
> the extended capabilities bitmap for this.
> 
Hi,

seems like this patch pushed wiphy info length over the limit
for dual band devices.
So userspace cannot get any info about phy capabilities.

I know there is a patch for nl80211 and iw to allow splitting of this info,
but it is not in 3.8
Should we not revert it for stable then?

Kind regards
Piotr

