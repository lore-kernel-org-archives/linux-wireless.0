Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZF3Kxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 06:53:31 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MLaxy-0002TD-7w
	for linux-wireless@vger.kernel.org; Tue, 30 Jun 2009 12:53:34 +0200
Message-Id: <20090630104952.857270082@sipsolutions.net>
Date: Tue, 30 Jun 2009 12:49:52 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] connect API, wext conversion
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches implements the connect API and
wext conversion for everything in mac80211. Other
drivers can be converted piece by piece, and then
later we can make wext more internal.

johannes

