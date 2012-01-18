Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab2AREKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 23:10:05 -0500
Received: from wireless by sipsolutions.net with local (Exim 4.77)
	(envelope-from <wireless@sipsolutions.net>)
	id 1RnMqZ-0005fC-1S
	for linux-wireless@vger.kernel.org; Wed, 18 Jan 2012 05:10:03 +0100
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v3.3
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1RnMqZ-0005fC-1S@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Wed, 18 Jan 2012 05:10:03 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v3.3) is available at:

http://wireless.kernel.org/download/iw/iw-3.3.tar.bz2

SHA1 sum: 5d167faf4e8a9b33d04170402f351b4da66a331f

Here is the short log of the changes (since v3.2)
included in this release:

Antonio Quartulli (1):
      iw: add support for NL80211_CMD_DEL_STATION event

Ben Greear (1):
      iw: Support ht-capability overrides mask.

Bjarke Istrup Pedersen (1):
      always use libnl 3.2 as 3.2, not 3.0

Felix Fietkau (1):
      iw: fix regression in tx power validation

Gilles Espinasse (2):
      Fix linking with libnl-3
      fix compilation against libnl-3.x

Johannes Berg (9):
      use genl_ctrl_resolve()
      Revert "Fix linking with libnl-3"
      remove NLVERSION from Makefile
      update nl80211.h
      update nl80211.h
      whitespace cleanups
      update nl80211.h
      parse NL80211_ATTR_FEATURE_FLAGS
      update version to 3.3

Nick Black (2):
      use signed int where negative values are used
      whitespace cleanups

Simon Wunderlich (2):
      iw: add support for NoAck per tid
      iw: add HT options for ibss

Yoni Divinsky (1):
      iw: fix wifi wmm ie print function

