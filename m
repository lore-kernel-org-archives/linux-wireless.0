Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60606 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXKIICS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 03:02:18 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
Subject: [PATCH 0/14] mac80211/iwlwifi (#everything): integrate IEEE802.11n support
Date: Fri,  9 Nov 2007 10:01:52 +0200
Message-Id: <1194595326527-git-send-email-ron.rindjunsky@intel.com> (sfid-20071109_080230_546084_6718B511)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches splits into two parts:
 - patches 1-7 add 802.11n support to mac80211.
 - patches 8-14 demonstrates the use of the above mac80211's 802.11n framework through iwl4965 low level driver
 
In order to be compatible with the 802.11n requirements for an HT station,
patches 1-7 should not be treated as stand alone patches, but as a complete framework,
although separation to patches by subjects was made for ease of handling.
This applies to patches 8-14 as well.
 
The patches do _not_ break any existing driver.
 
patches were made (and tested to work) with wireless branch 2.6.24-rc1 (#everything)
 
The framework includes the following:
- HT probing.
- HT association.
- Support in Rx A-MSDU.
- Support in A-MPDU apackage contains the ddBA request.
- HT information and configuration delivery to both low-level driver and rate scaling.
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
