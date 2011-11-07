Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1KGJdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 04:33:03 -0500
Received: from wireless by sipsolutions.net with local (Exim 4.77)
	(envelope-from <wireless@sipsolutions.net>)
	id 1RNLZe-0005kI-RP
	for linux-wireless@vger.kernel.org; Mon, 07 Nov 2011 10:33:02 +0100
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v3.2
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1RNLZe-0005kI-RP@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Mon, 07 Nov 2011 10:33:02 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v3.2) is available at:

http://wireless.kernel.org/download/iw/iw-3.2.tar.bz2

SHA1 sum: 2871d58ab1f8d5b2b8d548d57489873f21c085be

Here is the short log of the changes (since v0.9.22)
included in this release:

Christian Lamparter (1):
      iw: fix HT PHY BSS Membership selector value encoding

Helmut Schaa (1):
      iw: show STA flags in station dump

Javier Cardona (1):
      support for setting RANN interval and mesh gate

Jo-Philipp Wich (1):
      iw: Fix calculation of fractional multicast rates

Johannes Berg (30):
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
      update nl80211.h
      print roam capability
      show supported ciphers
      print PHY membership selector only for membership rates
      SSID printing: escape space at beginning end, backslash
      print wiphy idx in iface info
      update nl80211.h
      print PMKSA candidate event
      print out AP-side uAPSD support
      update version to 3.2

Paul Stewart (1):
      Add station BSS params to iw output

Sean Robinson (1):
      Add send callbacks with optional debug handler

Sujith Manoharan (1):
      iw: Clarify bitrate mask documentation

Yegor Yefremov (1):
      iw: add libnl-3.0 support

