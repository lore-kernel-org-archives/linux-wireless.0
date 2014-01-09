Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaAIMv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 07:51:27 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA256:128)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W1F53-0005No-Cq
	for linux-wireless@vger.kernel.org; Thu, 09 Jan 2014 13:51:25 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mac80211: AP/GO uAPSD/PS-Poll fixes
Date: Thu,  9 Jan 2014 13:51:18 +0100
Message-Id: <1389271882-15806-1-git-send-email-johannes@sipsolutions.net> (sfid-20140109_135131_062029_88301919)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In code review with Eliad and while adding more tests to my
iwlwifi testing, I found a few more issues - fix them.

johannes

