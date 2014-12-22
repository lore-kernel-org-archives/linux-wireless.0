Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33450 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbaLVM6O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2014 07:58:14 -0500
Message-ID: <1419253089.1890.13.camel@sipsolutions.net> (sfid-20141222_135817_555284_60259D69)
Subject: Re: [PATCH 1/2] brmc80211: dont use jiffies for BSS TSF
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Dec 2014 13:58:09 +0100
In-Reply-To: <20120313125919.370791280@sipsolutions.net> (sfid-20120313_140421_642123_6BC8E250)
References: <20120313125702.703540202@sipsolutions.net>
	 <20120313125919.370791280@sipsolutions.net>
	 (sfid-20120313_140421_642123_6BC8E250)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By the way - I know now that the proprietary Broadcom driver has the
same bug, to the point where this is apparently getting encoded into the
Android framework.

I urge you to fix this issue there as well. If an absolute "last
updated" timestamp is needed (and "last seen [ms] ago" isn't sufficient)
then new API will be needed.

johannes

