Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46181 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYKMEOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 23:14:49 -0500
Received: from [192.168.1.3] (jta11.roonets.jp [61.202.201.248])
	by mail.holtmann.org (Postfix) with ESMTP id 0ED898B2E5
	for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 05:14:47 +0100 (CET)
Message-Id: <BCB72601-9DA2-4D89-BDF1-7B96254DA17C@linux.intel.com> (sfid-20081113_051455_641044_00367D3B)
From: Marcel Holtmann <holtmann@linux.intel.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Issue with ifconfig down and 4965 driver
Date: Thu, 13 Nov 2008 05:14:42 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

so I am running a 2.6.28-rc4 kernel and every time I stop  
wpa_supplicant or call ifconfig down on the 4965 card, I get a user  
noticeable delay (mouse freezes). Seems that some part inside the  
driver is actively sleeping with a busy-loop. This is really not an  
acceptable behavior since it is a day-to-day task to bring the device  
down. And for power concerns, we really wanna allow to bring down the  
interface.

Regards

Marcel

