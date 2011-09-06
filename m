Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab1IFDKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 23:10:09 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.76)
	(envelope-from <wireless@sipsolutions.net>)
	id 1R0m33-0007I1-6Y
	for linux-wireless@vger.kernel.org; Tue, 06 Sep 2011 05:10:05 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v3.1
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1R0m33-0007I1-6Y@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Tue, 06 Sep 2011 05:10:05 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v3.1) is available at:

http://wireless.kernel.org/download/iw/iw-3.1.tar.bz2

SHA1 sum: 559636c4f73485db6fd4bf6f438e60fe5f23f569

Here is the short log of the changes (since v0.9.22)
included in this release:

Javier Cardona (1):
      support for setting RANN interval and mesh gate

Jo-Philipp Wich (1):
      iw: Fix calculation of fractional multicast rates

Johannes Berg (20):
      use nla_type
      report IBSS RSN
      fix frequency parsing
      print frame TX status event
      update nl80211.h
      validate tx power argument is a number
      update nl80211.h
      wowlan support
      update nl80211.h
      show interface combinations
      scan: print WPS UUID
      scan: print MS OUI as what it is
      a little bit of P2P parsing
      more verbose output for interface combinations
      update nl80211.h
      add set_rekey_offload cmd
      new wowlan triggers/info
      add remain-on-channel
      fix bug in version.sh
      update nl80211.h

Paul Stewart (1):
      Add station BSS params to iw output

Sean Robinson (1):
      Add send callbacks with optional debug handler

Sujith Manoharan (1):
      iw: Clarify bitrate mask documentation

