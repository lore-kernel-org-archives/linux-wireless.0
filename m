Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46535 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2EVRBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 13:01:37 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q4MH1aIR029404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 22 May 2012 10:01:36 -0700
Message-ID: <4FBBC670.1090200@candelatech.com> (sfid-20120522_190141_288397_12D2E291)
Date: Tue, 22 May 2012 10:01:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Any known reasons for ath9k being slow to send to AP?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We had a report where some smart-phone running iperf was significantly
faster than an i7 system running ath9k when sending TCP traffic to
an AP.

For receiving traffic FROM the AP, the i7/ath9k box was equally fast
or a bit faster.

Are there any known issues with ath9k sending (maybe incomplete
MPDU logic or similar)?

Kernel was 3.3.4+.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

