Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789AbXKOSFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 13:05:37 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 02/15] mac80211: adding 802.11n definitions inieee80211.h
Date: Thu, 15 Nov 2007 20:03:08 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB0406E64E@hasmsx411.ger.corp.intel.com> (sfid-20071115_180555_990000_7FE28704)
In-Reply-To: <1195133760.13846.58.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<flamingice@sourmilk.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> As 802.11n depends on and extends the 802.11e standard in several
issues,
>> there are also several definitions that belong to 802.11e.

> Btw. It appears that Broadcom implements at least block ack in non-HT
> STAs (they also implement aggregation but that isn't specified before
> 802.11n afaik). Is there any sense in supporting that?

IMHO, there is no point implementing any IEEE802.11e functionality that
has not been certificated or standardized by WFA as well, and non-HT STA
block ack falls into this category.

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
