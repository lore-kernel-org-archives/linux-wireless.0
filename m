Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1GTL6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 07:58:34 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.76)
	(envelope-from <wireless@sipsolutions.net>)
	id 1QjVQ9-0002Ml-3x
	for linux-wireless@vger.kernel.org; Wed, 20 Jul 2011 13:58:33 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v3.0
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1QjVQ9-0002Ml-3x@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Wed, 20 Jul 2011 13:58:33 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v3.0) is available at:

http://wireless.kernel.org/download/iw/iw-3.0.tar.bz2

SHA1 sum: 46817671757fae640d4ec3b36d54f4cc73604bad

Here is the short log of the changes (since v0.9.22)
included in this release:

Jo-Philipp Wich (1):
      iw: Fix calculation of fractional multicast rates

Johannes Berg (19):
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

Paul Stewart (1):
      Add station BSS params to iw output

Sean Robinson (1):
      Add send callbacks with optional debug handler

Sujith Manoharan (1):
      iw: Clarify bitrate mask documentation

