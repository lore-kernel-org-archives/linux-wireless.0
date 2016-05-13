Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39379 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbcEMUqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2016 16:46:07 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 3BC9A40BC03
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2016 13:46:05 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Support for 5/10Mhz channels in ath9k?
Message-ID: <57363D0C.2000808@candelatech.com> (sfid-20160513_224611_716436_2E04A5AC)
Date: Fri, 13 May 2016 13:46:04 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With some help, I found a patch to openwrt that enables hacking the
channel bandwidth to 5 or 10 for ath9k using debugfs 'chanbw' entry.

But, is there a way to do this through normal API?  Maybe something that
could be set in hostapd and/or wpa_supplicant if those apps were properly
patched?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

