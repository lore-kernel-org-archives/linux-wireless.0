Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56965 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab1K2SN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 13:13:58 -0500
Message-ID: <4ED520DD.8050606@candelatech.com> (sfid-20111129_191402_107257_C04D73D0)
Date: Tue, 29 Nov 2011 10:13:49 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Moving scan logic into work-queue?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We've talked before about moving the scan logic into the work-queue.

Since my previous attempts at optimizing this code for scanning & off-channel
work didn't stick, I thought I might attempt to convert the scan logic
to the work-queue, with hopes of then being able to make another attempt
at optimizing things for multiple interfaces & potentially off-channel work
items.

Before I start though, I'm hoping for some guidance on how you'd
want this implemented.  Or, if you think there are other changes
that should go in first, I'll wait...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

