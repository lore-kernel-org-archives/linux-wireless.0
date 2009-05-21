Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbZEUWC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 18:02:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1M7GLM-0006gf-5p
	for linux-wireless@vger.kernel.org; Fri, 22 May 2009 00:02:28 +0200
Message-Id: <20090521215940.344214804@sipsolutions.net>
Date: Thu, 21 May 2009 23:59:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT 0/4] rfkill improvements
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So this integrates rfkill into cfg80211 with the semantics
we discussed before. I've also ported iwlwifi for the fun
of it but due to lack of hardware can't test it. Help would
be appreciated a lot.

Note that this changes core kernel code so be prepared to
compile a lot of the kernel again.

johannes

