Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40803 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3AYSLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 13:11:49 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r0PIBiEu030028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 10:11:48 -0800
Message-ID: <5102CADE.2010900@candelatech.com> (sfid-20130125_191153_365070_17ACB728)
Date: Fri, 25 Jan 2013 10:11:42 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Increasing throughput on 3-radio system?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've put 3 ath9k AR9380 NICs into a single system (core-i7).  Each is
configured for an AP on a separate 5Ghz channel (40Mhz wide).

Individually, I can get about 300Mbps transmit towards the AP on any
particular radio, but when running all together, total throughput is
only about 475Mbps.

I assume there is some cross-channel bleeding or similar.

The APs are close by, so I was wondering if perhaps there was a way
to configure the radios to be less sensitive and thus pay less
attention to channel cross-talk?

Any suggestions for things to try are appreciated!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

