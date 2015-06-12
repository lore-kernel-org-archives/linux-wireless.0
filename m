Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59244 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752013AbbFLOA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 10:00:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: aspriel@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2015 17:00:40 +0300
Message-Id: <1434117644-3033-1-git-send-email-luca@coelho.fi> (sfid-20150612_160102_754090_19B51F09)
Subject: [PATCH py80211 0/4] py80211: add support for scheduled scan
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi Arend,

Here's a small patchset that adds support for scheduled scans in
py80211.

I'm not sure this is the right approach, I added separate classes for
each command, so feel free to ask me to change it completely if you
want and I may or may not do it. :P

Cheers,
Luca.

Luciano Coelho (4):
  py80211: scan: spin base scan classes off scan_request
  py80211: scan: add sched_scan start class
  py80211: add sched_scan stop class
  py80211: scan: add matchsets support for scheduled scans

 lib/scan.py | 157 +++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 119 insertions(+), 38 deletions(-)

-- 
2.1.4

