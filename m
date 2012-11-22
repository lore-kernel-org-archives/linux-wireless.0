Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:59642 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab2KVTRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:17:06 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [PATCH 0/3] mesh-related cleanups
Date: Wed, 21 Nov 2012 18:40:29 -0800
Message-Id: <1353552032-15600-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121122_201720_011325_67856EB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some cleanups requested by Johannes after the mesh powersave RFC.

Marco Porsch (3):
  mac80211: move Mesh Capability field definition to ieee80211.h
  mac80211: refactor ieee80211_set_qos_hdr
  mac80211: remove mesh config macros from mesh_plink.c

 include/linux/ieee80211.h |   14 ++++++++++++++
 net/mac80211/mesh.h       |   14 --------------
 net/mac80211/mesh_plink.c |   28 +++++++++++++---------------
 net/mac80211/wme.c        |   40 +++++++++++++++++++++++-----------------
 4 files changed, 50 insertions(+), 46 deletions(-)

-- 
1.7.9.5

