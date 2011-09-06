Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab1IFMQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 08:16:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R0ua2-00066G-1r
	for linux-wireless@vger.kernel.org; Tue, 06 Sep 2011 14:16:42 +0200
Message-Id: <20110906121421.460641040@sipsolutions.net> (sfid-20110906_141646_631700_311EFADF)
Date: Tue, 06 Sep 2011 14:14:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/3] some AP PS buffering rework
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was looking at AP side PS buffering for uAPSD
and found a number of things that need to be
improved first. This is what I've come up with
so far, comments would be appreciated.

Thanks everyone who already looked at this when
I asked them on IRC :-)

So far, it's pretty much untested.

johannes
