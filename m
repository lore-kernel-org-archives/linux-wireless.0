Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0LPOR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 09:17:27 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1PTEe6-0001AK-Ps
	for linux-wireless@vger.kernel.org; Thu, 16 Dec 2010 15:17:26 +0100
Message-Id: <20101216141518.879668720@sipsolutions.net>
Date: Thu, 16 Dec 2010 15:15:18 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/2] remain-on-channel HW offload
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds functionality to enable remain-on-channel
hardware offload to mac80211 drivers. Any frames
transmitted during that time get a new TX flag and
must be transmitted correctly by the driver -- any
other activity isn't stopped, so the device must
have different queues for the different frames.

johannes

