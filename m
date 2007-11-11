Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34040 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757304AbXKKUWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 15:22:09 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 12/14] iwlwifi: 802.11n comply HT add station flow withmac80211 framework
Date: Sun, 11 Nov 2007 22:21:03 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB0400879A@hasmsx411.ger.corp.intel.com> (sfid-20071111_202214_249708_E9FBEA38)
In-Reply-To: <1194627202.4793.152.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	<flamingice@sourmilk.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> +	/* TODO - consider checking if mac80211 will allow
>> +	 * to query its station table - will help here */

>Care to explain what you mean and how it'd help?

Oops sorry, I have already took this remark out, it was just a reminder
for 
me to ask you if you think that mac80211 should give the low-level
driver some kind of query option to its station table? It may save
double book keeping of station table to low-level driver?

>johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
