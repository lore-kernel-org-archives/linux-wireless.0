Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37192 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946365Ab2LFSRb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:31 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 00/13] qca-swiss-army-knife: initvals fixes and improvements
Date: Thu,  6 Dec 2012 19:17:14 +0100
Message-Id: <1354817847-23440-1-git-send-email-juhosg@openwrt.org> (sfid-20121206_191735_118175_8EA5640B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch-set contain patches for the initvals tool.
The first seven patches are fixing minor bugs, the next
three imporves the code a bit and the last four patches
are adding suport for AR9550.

Changes since v1:
  - rebase against the current version
  - add four new patch to fix more issues

Gabor Juhos (13):
  qca-swiss-army-knife: refresh checksums.txt
  qca-swiss-army-knife: fix ar9330_1p2_initvals.h
  qca-swiss-army-knife: print AR9565 initvals
  qca-swiss-army-knife: fix comment in ar9340_initvals.h
  qca-swiss-army-knife: add missing families to verify_checksums.sh
  qca-swiss-army-knife: fix string length for ar9340
  qca-swiss-army-knife: add ar9462-2p0 to the usage text
  qca-swiss-army-knife: reformat INI_PRINT_* macros
  qca-swiss-army-knife: simplify initval family handling
  qca-swiss-army-knife: allow to print initvals with more than 5 columns
  qca-swiss-army-knife: add initval support for AR955X
  qca-swiss-army-knife: add checksums for AR955X initvals
  qca-swiss-army-knife: allow to verify AR955X initvals

 tools/initvals/Makefile              |    2 +
 tools/initvals/ar9330_1p2_initvals.h |  132 +++-
 tools/initvals/ar9340_initvals.h     |    2 +-
 tools/initvals/ar955x_1p0_initvals.h | 1284 ++++++++++++++++++++++++++++++++++
 tools/initvals/checksums.txt         |   89 ++-
 tools/initvals/initvals.c            |  315 +++++----
 tools/initvals/verify_checksums.sh   |    2 +-
 7 files changed, 1659 insertions(+), 167 deletions(-)
 create mode 100644 tools/initvals/ar955x_1p0_initvals.h

--
1.7.10

