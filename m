Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970669AbXHMI5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 04:57:31 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IKVju-0007S6-6X
	for linux-wireless@vger.kernel.org; Mon, 13 Aug 2007 09:57:30 +0100
Message-Id: <20070813074504.416717000@sipsolutions.net>
Date: Mon, 13 Aug 2007 09:45:04 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] management interface removal
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first patch in the series is required to get hostapd working
with the monitor interface, the second cleans up some event sending
code and the third finally removes all the management interface.

Net weight:
 17 files changed, 75 insertions(+), 529 deletions(-)

johannes
