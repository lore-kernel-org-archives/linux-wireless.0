Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759115Ab2C3DKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 23:10:05 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.77)
	(envelope-from <wireless@sipsolutions.net>)
	id 1SDSDz-0006vk-0j
	for linux-wireless@vger.kernel.org; Fri, 30 Mar 2012 05:10:03 +0200
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v3.4
Reply-to: linux-wireless@vger.kernel.org
Message-Id: <E1SDSDz-0006vk-0j@sipsolutions.net>
From: wireless@sipsolutions.net
Date: Fri, 30 Mar 2012 05:10:03 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v3.4) is available at:

http://wireless.kernel.org/download/iw/iw-3.4.tar.bz2

SHA1 sum: 90e946f1f817455200ed029a92698f3cd2131cfd

Here is the short log of the changes (since v3.3)
included in this release:

Chun-Yeow Yeoh (2):
      iw: allow setting mesh mcast-rate
      iw: Add support of setting non-forwarding entity in Mesh

Johannes Berg (5):
      update nl80211.h
      shorten TX/RX frame type output
      update nl80211.h
      extend help framework
      update version to 3.4

Pontus Fuchs (1):
      Fix typo in print_iface_handler.

Simon Wunderlich (1):
      iw: remove ifdefs for mcs mask

