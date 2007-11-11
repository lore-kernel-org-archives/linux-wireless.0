Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12263 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279AbXKKUWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 15:22:06 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 02/14] mac80211: adding 802.11n definitions inieee80211.h
Date: Sun, 11 Nov 2007 22:20:13 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04008795@hasmsx411.ger.corp.intel.com> (sfid-20071111_202209_639216_4F1B3F0D)
In-Reply-To: <1194625601.4793.119.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	<flamingice@sourmilk.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> +struct ieee80211_bar {

Yes you are right, that is abbreviated for Block ACK Request

>> +struct ieee80211_ht_addt_info {

That's shortening for "HT additional info" which refers to 802.11n draft
section 7.3.2.53 "HT Information element".

The problem with this name results from terms confusion (IMHO) in the
draft.
Section 7.3.2.52 defines both "HT capabilities element" and "HT
Information element", but both are sent during association/beaconing, so
one may regard both as "information elements" (in classic IE way of
looking at them).

So currently ieee80211_ht_cap relates to "HT capabilities element" and
ieee80211_ht_addt_info relates to "HT Information element"
If anyone can think of a better naming convention to avoid confusion -
will be most appreciated.

Ron

> I'd appreciate comments what the abbreviations mean. I know bar (block
> ack request) but not sure about addt (add TS?)

Comments will be added

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
