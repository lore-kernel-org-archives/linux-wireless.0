Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44722 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753786AbbCQOMJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 10:12:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Mar 2015 16:11:46 +0200
Message-Id: <1426601510-8251-1-git-send-email-luca@coelho.fi> (sfid-20150317_151213_325617_F500D72C)
Subject: [PATCH iw v2 0/4] iw: add scheduled scan support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

This series adds scheduled scan support to the iw tool (finally! ;).

In v2, just rebased.

Luciano Coelho (4):
  iw: move generic sched scan parsing code out of net detect
  iw: implement scheduled scan
  iw: add support for active scheduled scan
  iw: add randomise option for sched_scan

 event.c  |   9 +++
 info.c   |   6 ++
 iw.h     |   4 +
 scan.c   | 266 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 wowlan.c | 174 ++---------------------------------------
 5 files changed, 292 insertions(+), 167 deletions(-)

-- 
2.1.4

