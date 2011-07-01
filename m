Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab1GAWPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 18:15:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Qcm09-0007Mq-Mg
	for linux-wireless@vger.kernel.org; Sat, 02 Jul 2011 00:15:53 +0200
Message-Id: <20110701221321.478559320@sipsolutions.net> (sfid-20110702_001559_666877_5A8663AA)
Date: Sat, 02 Jul 2011 00:13:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/3] cfg80211/mac80211 wowlan crypto offload
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is my current code for wowlan crypto offload.

It's still incomplete, but I figured I could use some
feedback.

Missing is access for the driver to IV/PN/RSC/TSC
so it can correctly check frames and use the right
one when sending frames. Will do that soon.

johannes

