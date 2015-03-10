Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41694 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbCJWaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 18:30:46 -0400
Received: from [192.168.100.236] (unknown [50.251.239.81])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 144F140AB5B
	for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 15:30:46 -0700 (PDT)
Message-ID: <54FF7095.9010800@candelatech.com> (sfid-20150310_233050_679616_05174300)
Date: Tue, 10 Mar 2015 15:30:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Why can we not set the mcast rate for AP/STA interfaces?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From looking at 3.17 code, it appears we are only supposed to set the
mcast rate for mesh and IBSS interfaces?

What if I want to tell an AP or station to send broadcast/multicast
at a higher than default rate?

Should this just be controlled by the normal 'iw setbitrates' logic?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

