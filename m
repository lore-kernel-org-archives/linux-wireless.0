Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1JNPMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 11:12:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1REjQz-0001OW-HY
	for linux-wireless@vger.kernel.org; Fri, 14 Oct 2011 17:12:29 +0200
Message-Id: <20111014151119.246288840@sipsolutions.net> (sfid-20111014_171233_879798_10B14603)
Date: Fri, 14 Oct 2011 17:11:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 00/12] no more mon.wlan0
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add infrastructure to get rid of the "cooked"
monitor interface in AP mode.

johannes

