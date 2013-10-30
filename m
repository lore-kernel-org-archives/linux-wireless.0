Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64685 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3J3VpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 17:45:13 -0400
Received: by mail-wg0-f42.google.com with SMTP id n12so6600210wgh.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 14:45:11 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/7] wireless-regdb: DFS regions and optimizations
Date: Wed, 30 Oct 2013 22:45:02 +0100
Message-Id: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131030_224518_160089_DDBBB36C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series associates a slew of countries
to DFS regions and then provides updates to 4
countries based on the new CRDA optimizer. The
optimizations have no functional changes other
than reducing the size of the regulatory domain
data strucutre that would be used to send to
the kernel.

Luis R. Rodriguez (7):
  wireless-regdb: add DFS FCC regions
  wireless-regdb: add DFS ETSI regions
  wireless-regdb: add DFS JP regions
  wireless-regdb: optimize two of DE's rules
  wireless-regdb: optimize two of ES's rules
  wireless-regdb: optimize two of IL's rules
  wireless-regdb: optimize two of NL's rules

 db.txt | 159 +++++++++++++++++++++++++++++++----------------------------------
 1 file changed, 77 insertions(+), 82 deletions(-)

-- 
1.8.4.rc3

