Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51026 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753831AbdKQA2D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 19:28:03 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 0A52B40A5ED
        for <linux-wireless@vger.kernel.org>; Thu, 16 Nov 2017 16:28:01 -0800 (PST)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: What would it take to get WDS working with channel contexts?
Message-ID: <24f85baf-5e19-a2c9-517d-9b69a47860d9@candelatech.com> (sfid-20171117_012807_810321_F19CD790)
Date: Thu, 16 Nov 2017 16:28:00 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a user interested in getting WDS working on ath10k, but evidently
this is not supported since ath10k uses channel-contexts:

 From net/mac80211/main.c:

		/*
		 * WDS is currently prohibited when channel contexts are used
		 * because there's no clear definition of which channel WDS
		 * type interfaces use
		 */


Anyone have any suggestions as to how this could be made to work?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
