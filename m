Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42661 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFZSUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 14:20:05 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id EDD2D40A79A
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2014 11:20:04 -0700 (PDT)
Message-ID: <53AC6454.5090605@candelatech.com> (sfid-20140626_202012_477893_089B637F)
Date: Thu, 26 Jun 2014 11:20:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Can we make ieee80211_iface_combination.limits non-const?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Depending on firmware loaded (and/or module options), a different
number of vdev interfaces may be supported.

Can we remove the const from the "struct ieee80211_iface_limit *limits"
member of ieee80211_iface_combination?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

