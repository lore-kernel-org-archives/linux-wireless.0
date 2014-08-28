Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.bemta12.messagelabs.com ([216.82.251.3]:22432 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934238AbaH1I2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 04:28:55 -0400
Message-ID: <53FEE812.2090402@netcommwireless.com> (sfid-20140828_102859_934015_629BF065)
Date: Thu, 28 Aug 2014 18:28:02 +1000
From: Sourav <sourav.chakraborty@netcommwireless.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: performance difference
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
We are using Ralink chip 3070 (using rt2800usb drivers rt2800usb.c), 
mac80211, and hostapd in our routers. When we are measuring performance 
using iperf, we see ~10Mbps which is around half of when we use rt3070 
drivers(rt3070.c). Please suggest a reason as to why we are seeing this 
performance difference.

Are there any mechanisms to tune performance using open source 
modules(hostapd and mac80211)?

-- 
Warm Regards,
Sourav


______________________________________________________________________
This communication contains information which may be confidential or privileged. The information is intended solely for the use of the individual or entity named above.  If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited.  If you have received this communication in error, please notify me by telephone immediately.
______________________________________________________________________
