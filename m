Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59059 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbbLCUQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 15:16:31 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 345DE40A959
	for <linux-wireless@vger.kernel.org>; Thu,  3 Dec 2015 12:16:31 -0800 (PST)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Can we increase IEEE80211_MAX_QUEUES
Message-ID: <5660A31E.3010507@candelatech.com> (sfid-20151203_211637_306021_AF98F120)
Date: Thu, 3 Dec 2015 12:16:30 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k wants to use vdev-id as a queue-id, and I want to support up to
64 vdevs.  In the 4.2 kernel, this is causing splats when using lots of
vdevs because then queue is out of range.

Can we just increase IEEE80211_MAX_QUEUES to 64?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

