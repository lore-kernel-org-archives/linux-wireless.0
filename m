Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gesmail.globaledgesoft.com ([106.51.250.152]:45888 "EHLO
	gesmail.globaledgesoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbaFEJDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 05:03:24 -0400
Received: from [172.16.6.109] (unknown [172.16.6.109])
	by gesmail.globaledgesoft.com (Postfix) with ESMTP id 841E658836C
	for <linux-wireless@vger.kernel.org>; Thu,  5 Jun 2014 14:20:10 +0530 (IST)
Message-ID: <539030ED.4020006@globaledgesoft.com> (sfid-20140605_110331_495286_57DDD02B)
Date: Thu, 05 Jun 2014 14:27:17 +0530
From: Gaurav Kumar Chauhan <ck.gaurav@globaledgesoft.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Physical carrier sensing (CCA)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am working on measuring channel load which requires knowledge of 
carrier sensing.

I am comfortable with virtual carrier sensing but not with physical 
carrier sensing.
I tried to google it but didn't get more than basics. I want to know 
about physical carrier
sensing in detail and where code for physical sensing is present.

Is it in driver or in firmware?
I am using atheros pci-express card and ath9k driver.

Please help me. Thanks in advance.

Regards,
Gaurav
