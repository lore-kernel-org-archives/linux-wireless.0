Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.jazztel.es ([62.14.3.170]:34914 "EHLO smtp01.jazztel.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759709AbZBER0h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 12:26:37 -0500
Received: from [87.219.174.145] (helo=localhost)
	by smtp01.jazztel.es with esmtpa (Exim 4.60)
	(envelope-from <arnau60@casal.upc.edu>)
	id 1LV7KX-0006ll-3C
	for linux-wireless@vger.kernel.org; Thu, 05 Feb 2009 17:43:57 +0100
Received: from arnau by localhost with local (Exim 4.63)
	(envelope-from <arnau60@casal.upc.edu>)
	id 1LV7Lu-0001vq-QS
	for linux-wireless@vger.kernel.org; Thu, 05 Feb 2009 17:45:22 +0100
Date: Thu, 5 Feb 2009 17:45:22 +0100
From: Arnau Roig <arnau60@casal.upc.edu>
To: linux-wireless@vger.kernel.org
Subject: txpower and frequency settings: concept guidance needed
Message-ID: <20090205164522.GA5580@purple> (sfid-20090205_182643_281266_66D68FD2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello to everybody.

I'm new in kernel development and in wireless networking also.
I've read most of the documentation availible in wireless.kernel.org
and, to be honest it's still not clear to me what are the uses of the
mac80211, cfg80211 or nl80211.

I'm using a 2.6.24 kernel, compat-wireless-2.6-old (compat-release
v4.5-g2badec7) and ath5k driver (v0.5.0).

What I want to do is a userspace application that has to modify the
frequency channel and the tx_power of the wireless device depending on
several network statistics. Please, where do I have to start looking?

Is the struct ieee80211_conf, declared in mac80211.h what I need for
changing the current working channel and tx_power?
Can I read network statistics with get_station, declared in the struct
cfg80211_ops in cfg80211.h? Or the way to do it is using
@NL80211_CMD_GET_WIPHY in nl80211_commands?

Thank you for your time.
