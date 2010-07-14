Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0GNRFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 13:05:39 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.72)
	(envelope-from <wireless@sipsolutions.net>)
	id 1OZ5Nm-0006OF-Fi
	for linux-wireless@vger.kernel.org; Wed, 14 Jul 2010 19:04:30 +0200
Date: Wed, 14 Jul 2010 19:04:30 +0200
Message-Id: <E1OZ5Nm-0006OF-Fi@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.20
Reply-to: linux-wireless@vger.kernel.org
From: wireless@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.20) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.20.tar.bz2

SHA1 sum: 75baf7d5fda2fb4e82c8c979caccc489d0170e45

Here is the short log of the changes included in this 
release:

Bruno Randolf (2):
      iw: fix makefile for cqm
      iw: add channel command name

Christian Lamparter (1):
      iw: fix ampdu spacing & max amsdu length reporting

Johannes Berg (19):
      update nl80211.h
      print unknown commands in supported list with number
      add off-channel command
      fix scan show_both_ie_sets
      update nl80211.h
      make commands array easier to handle
      update nl80211.h
      display unknown WPS TLVs
      print max scan IE length
      add hex parser util
      allow adding IEs to scan
      sync nl80211.h from wireless-testing
      fix number parsing bugs
      update nl80211.h from wireless-testing
      allow "link" command to print something for ibss
      split out multicast group adding
      improve connect vs. notification race behaviour
      update nl80211.h
      version 0.9.20

Jouni Malinen (2):
      iw: Add support for showing Beacon IEs and TIM IE
      iw: Parse some common WPS attributes

Juuso Oikarinen (1):
      iw: Add support for connection quality monitor configuation

Kalle Valo (1):
      iw: add set/get power_save commands

Luciano Coelho (1):
      iw: change install command to make it compatible with ancient coreutils

Luis R. Rodriguez (2):
      iw: add country IE parsing
      iw: fix typo on LDPC capability

Lukáš Turek (1):
      iw: Add support for NL80211_ATTR_WIPHY_COVERAGE_CLASS

Teemu Paasikivi (1):
      iw: Configure basic rates when joining ibss network

