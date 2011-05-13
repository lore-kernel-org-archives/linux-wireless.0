Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:43747 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab1EMQBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 12:01:20 -0400
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <i@lri.fr>)
	id 1QKuni-0004BY-5r
	for linux-wireless@vger.kernel.org; Fri, 13 May 2011 18:01:14 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QKunh-0003mn-6P
	for linux-wireless@vger.kernel.org; Fri, 13 May 2011 18:01:13 +0200
Date: Fri, 13 May 2011 18:01:13 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: WPA in ad-hoc mode with carl9170
Message-ID: <20110513160113.GA14293@zenon.in.qult.net> (sfid-20110513_180124_183247_CE794D6C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been trying to setup WPA using wpa_supplicant in an ad-hoc network,
specifically using AR9170 USB interfaces with the carl9170 driver and
firmware.

Although wpa_supplicant is supposed to be able to setup a single shared group
key for all communications, it appears at least the broadcast traffic is
neither enciphered at the sending end nor received at the receiving end
(tested with both TKIP and CCMP).

I was wondering whether this is supposed to work or it is just too soon.  If
there's anything that I could do to contribute, I'd be happy to help.

Thanks.

Ignacy

-- 
Sex on TV doesn't hurt....unless you fall off.
