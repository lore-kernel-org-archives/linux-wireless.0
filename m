Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:59985 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775AbXL2Njo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 08:39:44 -0500
Message-ID: <47764C5A.7060109@gentoo.org> (sfid-20071229_133951_204586_4374CA6E)
Date: Sat, 29 Dec 2007 13:32:10 +0000
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Strange mac80211 oops
References: <200712242237.28913.mb@bu3sch.de> <1198532736.4103.44.camel@johannes.berg> <1198533423.4103.46.camel@johannes.berg> <200712242328.56060.mb@bu3sch.de>
In-Reply-To: <200712242328.56060.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> So zd1211rw-mac80211 is pushing some unaligned data up the RX path, hm.

Johannes suggests that this may be due to QoS or WDS frames, which have 
headers that are 26 or 30 bytes. I don't recall seeing any logic in 
zd1211rw to correctly realign these.

Daniel

