Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3ARUoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 15:44:03 -0500
Received: from wireless by sipsolutions.net with local (Exim 4.80)
	(envelope-from <wireless@sipsolutions.net>)
	id 1TwInB-0003VY-Jh
	for linux-wireless@vger.kernel.org; Fri, 18 Jan 2013 21:44:01 +0100
To: linux-wireless@vger.kernel.org
Subject: [ANN] crda: v1.1.3
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1TwInB-0003VY-Jh@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Fri, 18 Jan 2013 21:44:01 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of crda (v1.1.3) is available at:

http://wireless.kernel.org/download/crda/crda-1.1.3.tar.bz2

SHA1 sum: 6e0adbfc0f5418a03d7d708bd39d52cd1325b511

Here is the short log of the changes (since v1.1.2)
included in this release:

Luis R. Rodriguez (15):
      crda: synch up nl80211.h
      crda: fix null string assumption for alpha2
      crda: add support to send DFS master region
      crda: use stdint.h instead of linux/types.h
      crda: move country2rd() and its helper to reglib.c
      crda: add a reglib iterator reglib_for_each_country()
      crda: make intersect.c use reglib_for_each_country()
      crda: close fd upon leaving
      crda: add new reglib_get_country_alpha2()
      crda: add dfs_region to the ieee80211_regdomain data structure
      crda: make crda use reglib_get_country_alpha2()
      crda: clean header files
      crda: make country2rd() static
      crda: make usage of regdb.h exclusive to reglib.c
      crda: rename reglib_get_*() routines

Stefan Lippers-Hollmann (1):
      crda: add nested support for libnl-3.2

