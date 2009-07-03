Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:34174 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbZGCHOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 03:14:08 -0400
Message-ID: <4A4DB01E.2030408@informatik.uni-kl.de>
Date: Fri, 03 Jul 2009 09:15:42 +0200
From: Reiner Herrmann <r_herrma@informatik.uni-kl.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211: Force beacon update?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I want to attach a custom IE to beacons, but some drivers (like b43)
are fetching their beacons via ieee80211_beacon_get() only once and
retransmit this beacon every time.
Some other drivers (like mac80211_hwsim, ath9k) are calling it
before every beacon transmission.

Is there a general way to make all drivers generate new beacons instead
of caching them or would I have to adapt them?
If adapting drivers is the only way, do you have any suggestions on
how to do that?

Thank you for your answers.

Regards,
  Reiner
