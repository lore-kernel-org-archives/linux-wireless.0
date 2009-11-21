Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZKUEKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 23:10:05 -0500
Received: from wireless by sipsolutions.net with local (Exim 4.69)
	(envelope-from <wireless@sipsolutions.net>)
	id 1NBhIY-0003bd-Bk
	for linux-wireless@vger.kernel.org; Sat, 21 Nov 2009 05:10:10 +0100
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.18
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1NBhIY-0003bd-Bk@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Sat, 21 Nov 2009 05:10:10 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.18) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.18.tar.bz2

SHA1 sum: b165aea1b41efe3f5249c381aabb120c63ddbe2f

Here is the short log of the changes included in this 
release:

Brian Cavagnolo (1):
      iw: fix NL80211_STA_INFO_PLINK_STATE printing in station dump

Eric Sesterhenn (1):
      fix fd leak in phy_lookup()

Felix Fietkau (2):
      iw: add a command for moving a STA into an AP VLAN
      iw: add support for setting the wds/4-address flag when creating an interface

Holger Schurig (2):
      iw: show age of last scan
      display noise level from survey data

Johannes Berg (8):
      update nl80211.h
      add netns command
      sync nl80211.h
      add trailing \n to fprintfs missing it
      update nl80211.h
      fix breakage
      fix mesh terminology
      version 0.9.18

Johannes Stezenbach (1):
      iw: use PKG_CONFIG variable consistently

John W. Linville (1):
      default install to $(PREFIX)/sbin

Marcel Holtmann (1):
      add support for showing NL80211_ATTR_SUPPORTED_COMMANDS

Rui Paulo (2):
      print a header before printing the list of mesh paths
      implement rootmode

