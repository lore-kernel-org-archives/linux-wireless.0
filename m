Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab2IBVsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 17:48:30 -0400
Message-ID: <1346622538.10113.3.camel@jlt4.sipsolutions.net> (sfid-20120902_234956_614143_22499F6F)
Subject: Re: [PATCH] p54: connect to 11w protected networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Sun, 02 Sep 2012 23:48:58 +0200
In-Reply-To: <E1T8ABt-0007Mx-CW@debian64.localnet> (sfid-20120902_152626_031643_E0FAEA94)
References: <E1T8ABt-0007Mx-CW@debian64.localnet>
	 (sfid-20120902_152626_031643_E0FAEA94)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-02 at 15:22 +0200, Christian Lamparter wrote:
> Previously, it was not possible to connect to
> networks which requires 11w to be supported by
> the stations.
> 
> This implementation relies on the mac80211
> stack to do the actual crypto operations, as
> there is no support for MFP in the firmware
> as far as I can tell.

Same notes about RX apply here, of course.

johannes

