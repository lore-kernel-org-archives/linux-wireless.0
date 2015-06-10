Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40526 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbFJVUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 17:20:18 -0400
Received: from [192.168.100.236] (unknown [50.251.239.81])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id F319440A1E9
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 14:20:17 -0700 (PDT)
Message-ID: <5578AA11.2020505@candelatech.com> (sfid-20150610_232022_833916_9A1896A2)
Date: Wed, 10 Jun 2015 14:20:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Add netdev name to  NL80211_CMD_STOP_AP event?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While trying to make 'iw' able to print out something useful for
the 'stop_ap' event, I notice there is not really any human friendly
info in the message (just phy id (which may not match phy name), ifindex, and some other
wiphy related numeric ID.

Any reason not to add the netdev name (NL80211_ATTR_IFNAME) to this and
related messages?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

