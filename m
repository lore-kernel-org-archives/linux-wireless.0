Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2LVEKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 23:10:08 -0500
Received: from wireless by sipsolutions.net with local (Exim 4.80)
	(envelope-from <wireless@sipsolutions.net>)
	id 1TmGPU-0000sY-HV
	for linux-wireless@vger.kernel.org; Sat, 22 Dec 2012 05:10:06 +0100
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v3.8
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1TmGPU-0000sY-HV@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Sat, 22 Dec 2012 05:10:04 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v3.8) is available at:

http://wireless.kernel.org/download/iw/iw-3.8.tar.bz2

SHA1 sum: 62f9b3eca379ada2db1a650e26655fbd645608f2

Here is the short log of the changes (since v3.7)
included in this release:

Antonio Quartulli (4):
      iw: show AP scan capability
      iw: add support for the forced AP scan
      iw: print the ssid when requesting device info
      iw: add set_mcast_rate command support

Ashok Nagarajan (1):
      iw: remove unnecessary variable in find_mesh_param

Johannes Berg (16):
      update nl80211.h
      update nl80211.h
      fix bug in iftype_name()
      update command list
      add P2P Device handling primitives
      parse more extended capabilities
      print VHT capabilities
      add a helper command to print command IDs
      update nl80211.h
      allow multiple command variants
      print VHT operation IE
      parse a few more IEs
      update nl80211.h
      update for VHT channel config
      update nl80211.h
      update version to 3.8

Pontus Fuchs (1):
      Clarify that unit is ms for ROC command

Sam Leffler (1):
      iw: add lowpri and flush scan operands

