Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48326 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbXKLHeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 02:34:18 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 01/14] mac80211: adding MAC80211_HT config variable
Date: Mon, 12 Nov 2007 09:33:35 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB0400893A@hasmsx411.ger.corp.intel.com> (sfid-20071112_073424_142478_9884012A)
In-Reply-To: <200711112224.08807.flamingice@sourmilk.net>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Cc: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>> This patch adds MAC80211_HT and MAC80211_HT_DEBUG config variables
>> to separate HT features
>>

> Nah. We don't need more ifdefs. Just leave the code on all the time.
The 
> overhead when it's not being used should be minimal and if it's not..
that 
> needs to be fixed anyway.

I was thinking of doing it, as patches do not break current drivers, but
wanted to give the option if desired. I do believe that overhead of the
patches when unused is minor, so unless someone will object I can remove
the #ifdefs.

Ron

> Also there doesn't appear to be MAC80211_HT_DEBUG in this patch,
though 
> I'd be 
> okay with that.

> -Michael Wu
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
