Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:41872 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751308AbbCMU1b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 16:27:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 13 Mar 2015 22:27:17 +0200
Message-Id: <1426278441-10304-1-git-send-email-luca@coelho.fi> (sfid-20150313_212736_164770_8FA4088A)
Subject: [PATCH iw 0/4] iw: add scheduled scan support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

This series adds scheduled scan support to the iw tool (finally! ;).

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

