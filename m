Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47703 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaJAXAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 19:00:41 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 7C11640A69D
	for <linux-wireless@vger.kernel.org>; Wed,  1 Oct 2014 16:00:40 -0700 (PDT)
Message-ID: <542C8798.30807@candelatech.com> (sfid-20141002_010044_639075_0C2FC189)
Date: Wed, 01 Oct 2014 16:00:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Setting legacy bit-rates no longer works?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried this on a 3.17.0-rc7+ kernel, but reported tx-rate stays at 54Mbps

iw dev sta1 set bitrates legacy-5 24

Driver is ath9k, but wpa_supplicant is configured to disable HT.

I'm going to go dig into this, but if someone has any suggestions,
please let me know.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

