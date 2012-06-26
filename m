Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab2FZDKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 23:10:04 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.80)
	(envelope-from <wireless@sipsolutions.net>)
	id 1SjMAE-0003yC-SW
	for linux-wireless@vger.kernel.org; Tue, 26 Jun 2012 05:10:03 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v3.5
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1SjMAE-0003yC-SW@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Tue, 26 Jun 2012 05:10:02 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v3.5) is available at:

http://wireless.kernel.org/download/iw/iw-3.5.tar.bz2

SHA1 sum: aa72bf771c7ef42c4cd57de26a5de1481185e052

Here is the short log of the changes (since v3.4)
included in this release:

Ashok Nagarajan (4):
      iw: allow user to enable vendor synchronization when joining mesh
      iw: add mesh conf parameter "mesh_sync_offset_max_neighor"
      iw: Allow setting RSSI threshold for peering
      iw: Show Toffset on station dump

Chun-Yeow Yeoh (1):
      iw: print out Mesh ID on scan

Guido Trentalancia (1):
      iw: fix the Makefile for multiple libnl installations

Johannes Berg (5):
      update nl80211.h
      update nl80211 to kernel 3.5 version
      update manpage for "iw help command"
      update command list and add script
      update version to 3.5

Pontus Fuchs (1):
      Add support for channel info in interface info

