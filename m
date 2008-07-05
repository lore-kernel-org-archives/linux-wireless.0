Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYGEKJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 06:09:27 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KF4hp-0003Ee-On
	for linux-wireless@vger.kernel.org; Sat, 05 Jul 2008 12:09:25 +0200
Message-Id: <20080705100655.419906000@sipsolutions.net> (sfid-20080705_120930_145183_54B9CAAA)
Date: Sat, 05 Jul 2008 12:06:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH/RFT 0/2] mac80211 virtual interface improvement
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since I complained a while ago about the state of the iface.c file
being a complete mess, I decided to just rewrite it.

Tested lightly (not in AP mode)

johannes

