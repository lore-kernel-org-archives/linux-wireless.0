Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbXJXKWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2007 06:22:20 -0400
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	flamingice@sourmilk.net
Subject: [PATCH 0/2] mac80211: [RFC] pass BSS info to low level driver
Date: Wed, 24 Oct 2007 12:22:10 +0200
Message-Id: <11932213323451-git-send-email-ron.rindjunsky@intel.com> (sfid-20071024_112243_901347_1D1266B9)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The next two patches introduce a framework that can replace existing set
of low-level driver calls for each advertised change of BSS IE (for erp, wmm)
with a single call. further more, this call can inform low-level driver about
association state changes.
PATCH 1/2 - general framework
PATCH 2/2 - shows how this framework replaces erp_ie_changed
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
