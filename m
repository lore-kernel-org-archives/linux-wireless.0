Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53527 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbbDVLAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 07:00:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1YksO6-0002uQ-5Q
	for linux-wireless@vger.kernel.org; Wed, 22 Apr 2015 13:00:14 +0200
Message-ID: <1429700411.2185.3.camel@sipsolutions.net> (sfid-20150422_130020_708890_1F813515)
Subject: Re: [PATCH 01/11] mac80211: add TX fastpath
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 22 Apr 2015 13:00:11 +0200
In-Reply-To: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net> (sfid-20150417_171606_577624_82458E43)
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20150417_171606_577624_82458E43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok so I'm going to merge this now, with the exception of patch 9 which
I'm not entirely happy with as posted.

johannes

