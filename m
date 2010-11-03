Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:49865 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab0KCOqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 10:46:07 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 0445E383F6
	for <linux-wireless@vger.kernel.org>; Wed,  3 Nov 2010 15:46:05 +0100 (CET)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1zTkAM-ckrM7 for <linux-wireless@vger.kernel.org>;
	Wed,  3 Nov 2010 15:46:04 +0100 (CET)
Received: from [192.168.9.142] (unknown [192.168.9.142])
	by aurora.create-net.org (Postfix) with ESMTPSA id 59365383D6
	for <linux-wireless@vger.kernel.org>; Wed,  3 Nov 2010 15:46:04 +0100 (CET)
Message-ID: <4CD175AB.7000002@create-net.org>
Date: Wed, 03 Nov 2010 15:46:03 +0100
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Transmission feedback in monitor mode
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

   Hi,


I'm looking for an example on how to use transmission
feedback on a device operating in monitor mode.

I've already managed to write an userlevel software (using the click
modular router) that injects packets over a monitor interface however
if I use wireshark to sniff the traffic from that interface
i see no tx feedback packets (albeit for example I can clearly
see that there are some retransmissions).

Is there a patch for making mac80211 use the IEEE80211_RADIOTAP_TX_FLAGS?

Thanks
R.

