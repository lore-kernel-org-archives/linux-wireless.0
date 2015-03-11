Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56787 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbbCKVH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 17:07:56 -0400
Received: from [192.168.100.236] (unknown [50.251.239.81])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id A881440B7F0
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2015 14:07:55 -0700 (PDT)
Message-ID: <5500AEAB.8010605@candelatech.com> (sfid-20150311_220759_158741_7D37E09B)
Date: Wed, 11 Mar 2015 14:07:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mac80211-hwsim and tx-rates.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using the user-space transport, the netlink frame sent to user-space
has a rate index and retry count, and nothing else.  Is there a
reliable way to know in user-space what index maps to what actual rate?

If not, any suggestions for how to improve this?  Maybe add
a new object that passes up a bunch more info about the actual
rates instead of just the rate idx?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

