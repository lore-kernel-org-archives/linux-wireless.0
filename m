Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60529 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2LNRuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 12:50:14 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id qBEHoD3C027971
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 09:50:13 -0800
Message-ID: <50CB66D5.6070900@candelatech.com> (sfid-20121214_185024_393287_1E46F699)
Date: Fri, 14 Dec 2012 09:50:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RSSI threshold events?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm seeing lots of these events in the 3.7.0+ kernel (and in 3.5 as well).

I *should* be connected to good APs that are only a few feet away.

Either way, maybe we should report the threshold and actual value
that caused the event to make it easier to figure out what the
problem is?

(My program has formatted this output slightly)

2012-12-14 09:47:05.154  1.1:  sta1055 (phy #2): connection quality monitor event: RSSI went below threshold
2012-12-14 09:47:05.156  1.1:  sta1056 (phy #2): connection quality monitor event: RSSI went below threshold
2012-12-14 09:47:05.158  1.1:  sta1057 (phy #2): connection quality monitor event: RSSI went below threshold
2012-12-14 09:47:05.160  1.1:  sta1058 (phy #2): connection quality monitor event: RSSI went below threshold
2012-12-14 09:47:05.163  1.1:  sta1059 (phy #2): connection quality monitor event: RSSI went below threshold
2012-12-14 09:47:05.164  1.1:  sta1060 (phy #2): connection quality monitor event: RSSI went below threshold

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

