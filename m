Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZF3Lxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 07:53:47 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MLbuH-0003Pq-3C
	for linux-wireless@vger.kernel.org; Tue, 30 Jun 2009 13:53:49 +0200
Message-Id: <20090630115245.675553951@sipsolutions.net>
Date: Tue, 30 Jun 2009 13:52:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/8 v3] connect API, wext conversion
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now with association request IEs where necessary,
and with a mac80211 patch to disable 11n again
depending on the configuration.

johannes

