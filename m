Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50019 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbbKPKiR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 05:38:17 -0500
Message-ID: <1447670285.2417.9.camel@sipsolutions.net> (sfid-20151116_113920_609321_0BA17300)
Subject: Re: [PATCH] wireless: change cfg80211 regulatory domain info as
 debug messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>, Dave Young <dyoung@redhat.com>,
	linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
Date: Mon, 16 Nov 2015 11:38:05 +0100
In-Reply-To: <1447609134.6012.15.camel@perches.com>
References: <20151115073105.GA18846@dhcp-128-65.nay.redhat.com>
	 <1447609134.6012.15.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> So maybe add some wrapper that does a pr_info then
> a pr_debug for the second and subsequent uses like:
> 

That seems like a bad idea - one might be tricked into think that one
saw the current data, but the actually current data is later hidden.

johannes
