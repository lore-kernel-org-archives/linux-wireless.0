Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39085 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2GaLoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:44:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwArp-0007VX-Mj
	for linux-wireless@vger.kernel.org; Tue, 31 Jul 2012 13:44:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 00/10] mac80211: multi-channel preparation & cleanups
Date: Tue, 31 Jul 2012 13:43:48 +0200
Message-Id: <1343735038-16030-1-git-send-email-johannes@sipsolutions.net> (sfid-20120731_134408_464728_6820C15E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While working towards multi-channel I found a few more issues
and things that could be cleaned up. I had most of these changes
in the RFC series already, but I'm splitting them out now and
will apply them before finishing the multi-channel code so that
there's less potential for conflict with what others may be
working now right now.

johannes

