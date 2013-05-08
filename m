Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60015 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3EHE6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 00:58:32 -0400
Received: from [50.54.140.2] (50-54-140-2.evrt.wa.frontiernet.net [50.54.140.2])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r484wVFC003722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 7 May 2013 21:58:31 -0700
Message-ID: <5189DB72.3020809@candelatech.com> (sfid-20130508_065845_266650_CC184910)
Date: Tue, 07 May 2013 21:58:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Fun with QoS in AP mode.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were doing some testing with ToS/QoS in some VOIP streams today.

The mappings on the station machine work fine, but on the AP, the packets
always go to the BE queue.  Both systems are 3.9.0+ ath9k, recent hostapd,
supplicant, etc.

The VOIP call traffic is going station to station, so the AP is just turning
the packets around..

Any ideas where to go poking?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

