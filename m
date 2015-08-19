Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36055 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbbHSTHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 15:07:52 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 68F9440A032
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2015 12:07:51 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Using ath5k/ath9k radio for constant-tx noise source.
Message-ID: <55D4D406.5000603@candelatech.com> (sfid-20150819_210756_303353_84D6844F)
Date: Wed, 19 Aug 2015 12:07:50 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a commercial AP that is using a CM9 ath5k radio (evidently, I could be wrong)
and it has the ability to do a constant transmit of raw noise (RF probe shows
noise, but a monitor-port sniffer does not see any frames from the CM9).

I don't know the low-level details of how it is doing this, but I suspect
it is using something like madwifi for a driver.

Does anyone know how this can be done with modern software and
ath5k or ath9k NICs?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

