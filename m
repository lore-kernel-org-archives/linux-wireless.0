Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50382 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbaJPMs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 08:48:57 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by gateway2.nyi.internal (Postfix) with ESMTP id 388252030B
	for <linux-wireless@vger.kernel.org>; Thu, 16 Oct 2014 08:48:57 -0400 (EDT)
Message-Id: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com> (sfid-20141016_144905_684037_C3674166)
From: =?UTF-8?Q?Lauren=C8=9Biu=20Nicola?= <lnicola@dend.ro>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: iwlwifi: Reason 7 periodic disconnect
Date: Thu, 16 Oct 2014 15:48:56 +0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm using iwlwifi for a Centrino Ultimate-N 6300 on 3.14.4 and 3.17.1.
Connect to my wireless network works, but I get disconnected every 60
seconds or so. The dmesg output looks like
https://bpaste.net/show/1623a8ae5dc6 .

I had the same issue on the three latest firmware versions:
iwlwifi-6000-ucode-9.176.4.1
iwlwifi-6000-ucode-9.193.4.1
iwlwifi-6000-ucode-9.221.4.1

The dmesg log actually shows the driver loading the different versions
above.

It's the first time I try to use wireless on Linux, so I might have made
a dumb mistake.

Thanks for any tips,
Laurentiu Nicola
