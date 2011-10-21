Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1JUOZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:25:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RHG1t-0008Qg-2O
	for linux-wireless@vger.kernel.org; Fri, 21 Oct 2011 16:25:01 +0200
Message-Id: <20111021142322.229128720@sipsolutions.net> (sfid-20111021_162510_209354_8FBBB6EB)
Date: Fri, 21 Oct 2011 16:23:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 00/12] get rid of AP mode monitor interfaces
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a resend, now with OBSS beacon receive that
allows implementing the right protection logic in
hostapd.

As far as I can tell, this is complete. Separate
hostapd/wpa_s patchset will be on the way shortly.

johannes
