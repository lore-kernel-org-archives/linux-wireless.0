Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10830 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbYKIAql (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 19:46:41 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: stable@vger.kernel.org, rjw@sisk.pl, linville@tuxdriver.com,
	reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] iwlwifi fixes for stable 2.6.27
Date: Sun,  9 Nov 2008 02:46:34 +0200
Message-Id: <1226191596-22192-1-git-send-email-tomas.winkler@intel.com> (sfid-20081109_014655_605798_FC01718A)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First one didn't make it into the stable due to type in emails
Second is important bug fix that was kept out 2.6.27 merging window.
There is no visible kernel bug but w/o this patch the 5000 iwlwifi HW 
is left un-calibrated which is critical.


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

