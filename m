Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759862Ab2C3LKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 07:10:18 -0400
Message-ID: <1333105815.3908.11.camel@jlt3.sipsolutions.net> (sfid-20120330_131022_444171_B95DE05C)
Subject: [PATCH 0/2] compat: fix extreme build slowdowns
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Mar 2012 13:10:15 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somehow exporting too many variables completely confuses the kernel's
Makefiles into trying to calculate the size of every file in a very slow
shell script ... this is causing EXTREME build slowdowns for me.

These two patches fix it.

johannes

