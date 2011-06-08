Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab1FHOFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 10:05:32 -0400
Date: Wed, 8 Jun 2011 16:05:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: bt coex active on iwlegacy?
Message-ID: <20110608140524.GB2283@redhat.com> (sfid-20110608_160536_750663_8F26BEB7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is bt_coex_active=true useful on iwlegacy? Or could be removed,
or assigned to false by default? I'm asking regarding random, rare
connections hangs and microcode errors that some people have on 4965.

Stanislaw
