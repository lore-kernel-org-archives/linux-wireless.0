Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1BDMdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 07:33:25 -0500
Received: from wireless by sipsolutions.net with local (Exim 4.72)
	(envelope-from <wireless@sipsolutions.net>)
	id 1PlKqr-0001j4-1U
	for linux-wireless@vger.kernel.org; Fri, 04 Feb 2011 13:33:25 +0100
Date: Fri, 04 Feb 2011 13:33:25 +0100
Message-Id: <E1PlKqr-0001j4-1U@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.22
Reply-to: linux-wireless@vger.kernel.org
From: wireless@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.22) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.22.tar.bz2

SHA1 sum: a91226daab473d1aa0b6586c61f1c62db9618b7d

Here is the short log of the changes included in this 
release:

Bill Jordan (1):
      iw: new command to set the wds peer

Bruno Randolf (5):
      iw: print station retry counters
      iw: Add ibss join parameter for beacon interval
      iw: Add antenna configuration commands
      iw: Add antenna configuration
      iw: Add signal average to station dump information

Felix Fietkau (3):
      iw: survey: Mark frequency in use
      iw: Add channel busy time to survey
      iw: add multicast rates to IBSS join

Jochen Friedrich (1):
      iw: Implement set 4addr.

Johannes Berg (25):
      fix NL80211_ATTR_MAX_SCAN_IE_LEN attribute size
      flush stdout after each event
      parse RSN IE information on PMKIDs and mgmt cipher suite
      update nl80211.h
      add p2p interface types
      fix some indentation
      event parsing: remove PARSE_BEACON_CHAN
      update nl80211.h
      clean up some messages
      events: allow relative timestamps
      genl: include genetlink.h explicitly
      update nl80211.h
      allow sub-command selection
      Revert "update nl80211.h"
      Revert "iw: Add antenna configuration commands"
      mesh: allow getting all parameters at once
      mesh: allow setting multiple parameters at once
      update nl80211.h
      mesh: support join/leave
      mesh: add support for NL80211_MESHCONF_ELEMENT_TTL
      update nl80211.h
      parse NL80211_ATTR_CQM_PKT_LOSS_EVENT
      add unprot events
      add more command names
      version 0.9.22

Jouni Malinen (1):
      iw: parse michael MIC failure event

Luis R. Rodriguez (2):
      iw: print out eirp for triplets on scan
      iw: fix country print

