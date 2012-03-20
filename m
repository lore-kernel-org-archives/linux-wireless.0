Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53788 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2CTTr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 15:47:59 -0400
Message-ID: <4F68DEE8.60506@candelatech.com> (sfid-20120320_204802_888444_92D81046)
Date: Tue, 20 Mar 2012 12:47:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: avg-signal is weird in ath9k in 3.3.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm testing out some code to get a stations's avg-signal through ethtool-stats,
and both it and /proc/net/wireless show ranges bouncing all over
(from around -48 to -110) on an interface running heavy traffic.

Are there any known bugs in 3.3.0 related to this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

