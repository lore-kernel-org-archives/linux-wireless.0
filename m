Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41554 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358Ab1EMXgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 19:36:09 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p4DNa83r017821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 16:36:08 -0700
Message-ID: <4DCDC068.9060307@candelatech.com> (sfid-20110514_013630_267564_B2988181)
Date: Fri, 13 May 2011 16:36:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Can't get hostapd to start, channels are all passive-scanning?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any idea what would cause all of my 5Ghz channels to be passive
scanning (which keeps hostapd from being able to use them, evidently)

		Frequencies:
			* 5180 MHz [36] (17.0 dBm) (passive scanning, no IBSS)
			* 5200 MHz [40] (17.0 dBm) (passive scanning, no IBSS)
			* 5220 MHz [44] (17.0 dBm) (passive scanning, no IBSS)
			* 5240 MHz [48] (17.0 dBm) (passive scanning, no IBSS)
			* 5260 MHz [52] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5280 MHz [56] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5300 MHz [60] (18.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5320 MHz [64] (18.0 dBm) (passive scanning, no IBSS, radar detection)

Another ath9k nearby, with same 'iw reg get' info and a slightly
different ath9k NIC shows this:


		Frequencies:
			* 5180 MHz [36] (17.0 dBm)
			* 5200 MHz [40] (17.0 dBm)
			* 5220 MHz [44] (17.0 dBm)
			* 5240 MHz [48] (17.0 dBm)
			* 5260 MHz [52] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5280 MHz [56] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5300 MHz [60] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5320 MHz [64] (20.0 dBm) (passive scanning, no IBSS, radar detection)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

