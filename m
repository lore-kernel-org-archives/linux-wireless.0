Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1GGRAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 13:00:43 -0400
Message-Id: <20110707165759.856063840@sipsolutions.net> (sfid-20110707_190047_192330_4BF9CEF4)
Date: Thu, 07 Jul 2011 18:57:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] more crypto access for drivers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the TID 0 vs. non-QoS issue out of the way
I'm happy with these now. Will need additional
code (separate patch) for keeping the connection
up (and safe) after resume, but I'm not there
yet. For now this allows me to keep the it up
and safe into suspend with GTK rekey in the
device.

johannes

