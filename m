Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:35906 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758925AbYDAVjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 17:39:39 -0400
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][PATCH 0/4] p54: various updates
Cc: Michael Wu <flamingice@sourmilk.net>
MIME-Version: 1.0
Date: Tue, 1 Apr 2008 23:39:36 +0200
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804012339.37204.chunkeey@web.de> (sfid-20080401_223943_580841_30803FEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this is the next RFC round...

1) rename all prism54* to p54* (to match the filenames)
2) rx_tasklet for p54pci
3) link statistics
4) AP-Patch 

Signed-off-by: Christian Lamparter <chunkeey@web.de>

---
diffstat: 
 p54.h       |   40 ++++
 p54common.c |  487 
++++++++++++++++++++++++++++++++++++++++++++++++------------
 p54common.h |  111 ++++++++++---
 p54pci.c    |  283 ++++++++++++++++++++++------------
 p54pci.h    |   20 +-
 p54usb.c    |   34 ++--
 p54usb.h    |    6
 7 files changed, 726 insertions(+), 255 deletions(-)
