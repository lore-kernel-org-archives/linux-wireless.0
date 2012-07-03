Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51907 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab2GCQtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:49:39 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 00/10] qca-swiss-army-knife: initvals fixes and improvements
Date: Tue,  3 Jul 2012 18:42:45 +0200
Message-Id: <1341333775-14091-1-git-send-email-juhosg@openwrt.org> (sfid-20120703_184944_660439_8A16CEE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch-set contain patches for the initvals tool. 
The first three patches are fixing minor bugs, the next 
three imporves the code a bit and the last four patches 
are adding suport for AR9550. 

Gabor Juhos (10):
  qca-swiss-army-knife: fix string length for ar9340
  qca-swiss-army-knife: add ar9462-2p0 to the usage text
  qca-swiss-army-knife: add ar9462-2p0 to verify_checksums.sh
  qca-swiss-army-knife: reformat INI_PRINT_* macros
  qca-swiss-army-knife: simplify initval family handling
  qca-swiss-army-knife: allow to print initvals with more than 5 columns
  qca-swiss-army-knife: add initval support for AR955X
  qca-swiss-army-knife: add checksums for AR955X initvals
  qca-swiss-army-knife: generate ath9k specific initvals for AR955X
  qca-swiss-army-knife: allow to verify AR955X initvals

 tools/initvals/Makefile              |    2 +
 tools/initvals/ar955x_1p0_initvals.h | 1284 ++++++++++++++++++++++++++++++++++
 tools/initvals/checksums.txt         |   16 +
 tools/initvals/initvals.c            |  293 +++++----
 tools/initvals/verify_checksums.sh   |    2 +-
 5 files changed, 1477 insertions(+), 120 deletions(-)
 create mode 100644 tools/initvals/ar955x_1p0_initvals.h

-- 
1.7.2.1

