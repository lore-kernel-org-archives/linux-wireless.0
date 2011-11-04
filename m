Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1KDKVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:21:05 -0400
Message-Id: <20111104101809.711636760@sipsolutions.net> (sfid-20111104_112109_507094_F592CE22)
Date: Fri, 04 Nov 2011 11:18:09 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/12] monitor-less AP mode part 1
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the first batch of patches. With these, it will work, but
not get EAPOL TX status. The socket option for that is still pending
review on netdev, but these patches can stand alone, and hostapd can
even work with just these w/o EAPOL TX status, just not completely
compliant.

johannes

