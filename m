Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab2COSTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:19:16 -0400
Subject: RE: [PATCH v2] wireless: rename ht_info to ht_operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430836909651@SC-VEXCH1.marvell.com>
References: <1331806879.3432.7.camel@jlt3.sipsolutions.net>
	 (sfid-20120315_112131_819302_49364FC7) <1331823014.3432.23.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F70430836909651@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 19:19:10 +0100
Message-ID: <1331835550.3432.29.camel@jlt3.sipsolutions.net> (sfid-20120315_191923_464898_44F0B52C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> For mwifiex part, the change looks fine except for a couple checkpatch warnings.

Ok, thanks. I knew there were going to be checkpatch warnings but
decided that the code wasn't going to be easier to read if I forced it
down to 80 colums, so decided to leave them.

johannes


