Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34870 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbbKDX6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 18:58:06 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 27E4140A959
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2015 15:58:05 -0800 (PST)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Configurable scan dwell time?
Message-ID: <563A9B8C.3060503@candelatech.com> (sfid-20151105_005810_145706_585F3873)
Date: Wed, 4 Nov 2015 15:58:04 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks to me like the channel dwell time when scanning (SW scanning, mac80211)
is fixed at 1/9 of a second.  I'd like to make this configurable...is that something
that might be welcome upstream?

My plan is to add to the netlink API around starting a scan and allow user-space to
configure a dwell time in milliseconds.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

