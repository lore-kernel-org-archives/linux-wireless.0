Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZDVPru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 11:47:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Lweft-0004kN-65
	for linux-wireless@vger.kernel.org; Wed, 22 Apr 2009 17:47:49 +0200
Message-Id: <20090422154559.528196740@sipsolutions.net> (sfid-20090422_174753_922175_623E8F6D)
Date: Wed, 22 Apr 2009 17:45:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/2] mac80211 maintenance
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are two large mac80211 maintenance patches (including driver updates)
that fix some of the callback mess.

Comments welcome -- especially on the driver changes!

johannes

