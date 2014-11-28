Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40856 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaK1LeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 06:34:17 -0500
Message-ID: <1417174450.27562.0.camel@sipsolutions.net> (sfid-20141128_123429_788453_786251F1)
Subject: Re: [PATCH] nl80211: Fix a null dereference issue in
 nl80211_send_iface on removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Nov 2014 12:34:10 +0100
In-Reply-To: <1417174379-7150-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20141128_123317_336378_911A7066)
References: <1417174379-7150-1-git-send-email-tomasz.bursztyka@linux.intel.com>
	 (sfid-20141128_123317_336378_911A7066)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-28 at 13:32 +0200, Tomasz Bursztyka wrote:
> There is no need trying to add any channels information in the nelink
> message when the interface is being removed.

Already fixed.

johannes

