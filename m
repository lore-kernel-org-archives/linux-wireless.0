Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59933 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1JQRjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 13:39:45 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p9HHdhux024338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 17 Oct 2011 10:39:43 -0700
Message-ID: <4E9C685E.8000504@candelatech.com> (sfid-20111017_193949_170093_C284FD94)
Date: Mon, 17 Oct 2011 10:39:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Question on forcing stations to be in particular a/b/g/n & HT mode.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

We've had good luck with virtualizing lots of stations
and having them talk to various APs.  Now, I'd like to
improve on this a bit and be able to control some of
the options for individual clients such as HT-40 v/s HT-20,
Limit to /g even if /a/b/g/n is supported, etc.  The kernel
side of this will be the ath9k driver.

I would be grateful for pointers if any of this can
currently be done, or to areas in the hostapd and/or kernel
code that would need modifying to support this.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

