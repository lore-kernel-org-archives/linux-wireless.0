Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1GFMNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 08:13:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1QeQz3-0004CF-H1
	for linux-wireless@vger.kernel.org; Wed, 06 Jul 2011 14:13:37 +0200
Message-Id: <20110706121236.333408679@sipsolutions.net> (sfid-20110706_141342_026845_1465DEEF)
Date: Wed, 06 Jul 2011 14:12:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/2] more crypto access for drivers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I need these for WoWLAN GTK rekeying in the device -- comments?

I haven't implemented the wakeup part yet, we might not even
be able to and may have to reconnect on resume, still checking.

johannes

