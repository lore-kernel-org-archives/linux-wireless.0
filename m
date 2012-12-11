Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2LKTYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 14:24:32 -0500
Message-ID: <1355253894.9819.10.camel@jlt4.sipsolutions.net> (sfid-20121211_202435_077205_82B914FD)
Subject: Re: [PATCH v2 1/2] mac80211: flush AP_VLAN stations when tearing
 down the BSS AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Dec 2012 20:24:54 +0100
In-Reply-To: <1355253650.9819.9.camel@jlt4.sipsolutions.net> (sfid-20121211_202033_834298_7C1D927D)
References: <1355166155-78532-1-git-send-email-nbd@openwrt.org>
	 <1355253650.9819.9.camel@jlt4.sipsolutions.net>
	 (sfid-20121211_202033_834298_7C1D927D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 20:20 +0100, Johannes Berg wrote:
> Applied.

Ok looking at the code I changed my mind ... I don't love the double
iteration but I think it's better than getting the ordering wrong so I
changed the patch a bit.

johannes

