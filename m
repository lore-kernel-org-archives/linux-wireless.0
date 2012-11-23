Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:54269 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab2KWUxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:53:24 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFCv2 0/4] iw: mesh power save
Date: Fri, 23 Nov 2012 12:53:10 -0800
Message-Id: <1353703994-13093-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_215334_610948_3C232A77)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commits cover neccessary iw commands for mesh power save.
Beacon interval, DTIM period, default power mode and awake window are accessed
as part of the mesh params. The link-specific power modes are station-specific.

v2:
-beacon interval and DTIM period set as part of mesh join -> no change during
 mesh runtime anymore

Marco Porsch (4):
  iw: add beacon interval and DTIM period parameters to mesh join
  iw: add default mesh power mode to mesh config
  iw: add support for link-specific mesh power modes
  iw: add mesh awake window to mesh config

 mesh.c    |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 station.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+), 4 deletions(-)

-- 
1.7.9.5

