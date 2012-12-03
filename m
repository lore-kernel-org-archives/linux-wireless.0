Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57884 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2LCWo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 17:44:28 -0500
Message-ID: <50BD2B46.5080706@candelatech.com> (sfid-20121203_234448_080378_A7A14FC4)
Date: Mon, 03 Dec 2012 14:44:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Allow over-riding regdomain in NIC when CFG80211_CERTIFICATION_ONUS
 is enabled?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are out-of-tree patches for ath9k (at least) that allow overriding the
eeprom reg domain via a module option.

Any chance something like that could make it upstream if it were dependent
on CFG80211_CERTIFICATION_ONUS?

(We recently got a batch of wpea-127n NICs with country-code of TW, which
reminded me of this problem).

Thanks,
Ben
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

