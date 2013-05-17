Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3EQOZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 10:25:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UdLbO-0004MR-Up
	for linux-wireless@vger.kernel.org; Fri, 17 May 2013 16:25:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/2] cfg80211: SME refactoring
Date: Fri, 17 May 2013 16:25:41 +0200
Message-Id: <1368800743-29877-1-git-send-email-johannes@sipsolutions.net> (sfid-20130517_162552_352245_9958C92C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the cleanups, this is really what I was after, separating
the cfg80211 internal software SME from the SME event processing
that is needed for all three SMEs (userspace, cfg80211, driver.)

I have only lightly tested it so far, any help would be welcome :-)

johannes
