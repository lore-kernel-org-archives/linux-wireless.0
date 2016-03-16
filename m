Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.student.tuwien.ac.at ([193.170.74.22]:52348 "EHLO
	mail2.student.tuwien.ac.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934990AbcCPPEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 11:04:49 -0400
Received: from [192.168.0.203] ([212.69.186.40])
	(authenticated bits=0)
	by mail2.student.tuwien.ac.at (8.13.8/8.13.8) with ESMTP id u2GF4kD9013265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 16:04:46 +0100
From: Stefan Feirer <e0926020@student.tuwien.ac.at>
Subject: Hardware support 802.11k&r
To: linux-wireless@vger.kernel.org
Message-ID: <56E9760E.3000300@student.tuwien.ac.at> (sfid-20160316_160456_004840_002B2FA2)
Date: Wed, 16 Mar 2016 16:04:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm looking for hardware which supports 802.11k and 802.11r.
So far I'v tried two USB-Wifi Dongle with Realtek Chipsets (RTL8192CU 
and MT7610U). For both Realtek says 802.11k&r are supported but I 
couldn't get it work.
 From my point of view the problem with the realtek chipsets is that 
both use the old wext wifi driver and wext doesn't support 802.11k&r.

Can anyone recommend wifi hardware which supports 802.11k&r?
Has anyone experience with 802.11k&r?

Thanks,
Stefan Feirer
