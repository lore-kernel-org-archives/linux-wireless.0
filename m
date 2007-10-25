Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbXJYNWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:22:30 -0400
Received: from [131.234.198.68]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Il2fM-0000cp-Qm
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2007 14:22:29 +0100
Message-Id: <20071025093618.440937000@sipsolutions.net> (sfid-20071025_142242_650160_9EE134E9)
Date: Thu, 25 Oct 2007 11:36:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [patch 0/9] initial round of hostapd support patches
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that 2.6.24-rc1 is released I guess I can throw more new
patches at you :)

This is a first piece of hostapd support patches, these introduce
new nl80211 API.

I do not think these patches will apply since I left out some, but
comments would nonetheless be greatly appreciated.

johannes

