Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48824 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2KQGtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:49:49 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC 0/4] iw: mesh power save
Date: Fri, 16 Nov 2012 22:49:35 -0800
Message-Id: <1353134979-13314-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074952_356348_6A9154AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commits cover neccessary iw commands for mesh power save.
Beacon interval, DTIM period, default power mode and awake window are accessed
as part of the mesh params. The link-specific power modes are station-specific.

Marco Porsch (4):
  iw: add beacon interval and DTIM period to mesh config
  iw: add default mesh power mode to mesh config
  iw: add support for link-specific mesh power modes
  iw: add mesh awake window to mesh config

 mesh.c    |   57 +++++++++++++++++++++++++++++++++++++--
 station.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 2 deletions(-)

-- 
1.7.9.5

