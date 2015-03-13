Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:41320 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751732AbbCMMRT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 08:17:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 13 Mar 2015 14:17:05 +0200
Message-Id: <1426249027-22165-1-git-send-email-luca@coelho.fi> (sfid-20150313_131722_715049_83259602)
Subject: [PATCH iw 0/2] add option to pass initial delay to net-detect
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Just adding a cover-letter because of the nl80211.h update.

This patchset adds an option to add an initial delay before the
net-detect scans start running.

Luciano Coelho (2):
  update nl80211.h
  iw: add a delay option to net-detect

 nl80211.h | 207 ++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 wowlan.c  |  31 ++++++++--
 2 files changed, 203 insertions(+), 35 deletions(-)

-- 
2.1.4

